
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../core/constant/utils/appPrefHelper.dart';
import '../../../core/constant/utils/saveValues.dart';
import '../../inbox/presentation/inbox_screen.dart';
import '../state/login_state.dart';

final loginProvider =
StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier();
});

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(const LoginState());

  final SaveValues _saveValues = SaveValues();
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void validateForm(GlobalKey<FormState> formKey) {
    state = state.copyWith(
      isButtonEnabled: formKey.currentState?.validate() ?? false,
    );
  }

  /// Toggle password
  void togglePassword() {
    state = state.copyWith(
      passwordVisible: !state.passwordVisible,
    );
  }

  /// Remember me toggle
  void toggleRememberMe(bool value) {
    state = state.copyWith(rememberMe: value);
  }

  /// Enable button
  void setButtonEnabled(bool value) {
    state = state.copyWith(isButtonEnabled: value);
  }



  /// ---------------- LOAD REMEMBER ME ----------------

  Future<void> loadRememberedEmail() async {
    final remember =
        await _saveValues.getBool(AppPreferenceHelper.REMEMBER_ME) ?? false;

    if (remember) {
      final email =
          await _saveValues.getString(AppPreferenceHelper.EMAIL_ADDRESS) ?? '';
      emailController.text = email;
      state = state.copyWith(rememberMe: true);
    } else {
      emailController.clear();
      state = state.copyWith(rememberMe: false);
    }

    // ❌ NEVER remember password
    passwordController.clear();

    validateForm(_formKey);
  }

  Future<void> loginUsers(BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);

      /// Save remember me
      if (state.rememberMe) {
        await _saveValues.saveBool(
            AppPreferenceHelper.REMEMBER_ME, true);

        await _saveValues.saveString(
          AppPreferenceHelper.EMAIL_ADDRESS,
          emailController.text,
        );
      } else {
        await _saveValues.clearPrefValue(
            AppPreferenceHelper.REMEMBER_ME);

        await _saveValues.clearPrefValue(
            AppPreferenceHelper.EMAIL_ADDRESS);
      }

      /// simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      /// stop loading
      state = state.copyWith(isLoading: false);

      /// ✅ SAFE navigation
      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const InboxScreen(),
        ),
      );
    } catch (e) {
      print("LOGIN ERROR: $e"); // 👈 VERY IMPORTANT
      state = state.copyWith(isLoading: false);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed")),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
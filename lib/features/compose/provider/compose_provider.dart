import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constant/utils/appPrefHelper.dart';
import '../../../core/constant/utils/saveValues.dart';
import '../state/compose_state.dart';


final composeProvider = StateNotifierProvider<ComposeNotifier,
    ComposeState>((ref) => ComposeNotifier(),);

class ComposeNotifier extends StateNotifier<ComposeState> {
  ComposeNotifier() : super(const ComposeState());

  final SaveValues _saveValues = SaveValues();

  TextEditingController toController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController bodyController = TextEditingController();


  /// Load email from storage
  Future<void> loadEmail() async {
    final storedEmail =
    await _saveValues.getString(AppPreferenceHelper.EMAIL_ADDRESS);

    state = state.copyWith(email: storedEmail ?? "");
  }

}
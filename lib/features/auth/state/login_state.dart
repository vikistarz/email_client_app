class LoginState{
  final bool isButtonEnabled;
  final bool isLoading;
  final bool passwordVisible;
  final bool rememberMe;
  final String message;

  const LoginState({
    this.isButtonEnabled = false,
    this.isLoading = false,
    this.passwordVisible = false,
    this.rememberMe = false,
    this.message = "",
  });

  LoginState copyWith({
    bool? isButtonEnabled,
    bool? isLoading,
    bool? passwordVisible,
    bool? rememberMe,
    String? message,
  }) {
    return LoginState(
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      isLoading: isLoading ?? this.isLoading,
      passwordVisible: passwordVisible ?? this.passwordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
      message: message ?? this.message,
    );
  }
}
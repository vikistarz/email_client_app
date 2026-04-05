class ComposeState {
  final bool isLoading;
  final String email;
  final String errorMessage;

  const ComposeState({
    this.isLoading = false,
    this.email = "",
    this.errorMessage = "",
  });

  ComposeState copyWith({
    bool? isLoading,
    String? email,
    String? errorMessage,
  }) {
    return ComposeState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
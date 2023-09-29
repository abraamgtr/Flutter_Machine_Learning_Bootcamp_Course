class SignInState {
  SignInState({this.isLogedIn, this.email});

  bool? isLogedIn = false;
  String? email = "";

  SignInState copyWith({bool? isLogedIn, String? email}) {
    return SignInState(
        isLogedIn: isLogedIn ?? false, email: email ?? "test@email.com");
  }
}

class LoginDto {
  final String email;
  final String password;
  final bool rememberMe;

  LoginDto({
    required this.email,
    required this.password,
    required this.rememberMe,
  });
}

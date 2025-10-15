import '../../repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository _repository;

  LoginUser(this._repository);

  Future<Map<String, dynamic>?> call(
      String usernameOrEmail, String password, bool rememberMe) async {
    return await _repository.login(usernameOrEmail, password, rememberMe);
  }
}

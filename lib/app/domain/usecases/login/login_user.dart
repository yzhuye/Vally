import 'package:vally_app/app/data/repositories/auth/auth_repository.dart';

class LoginUser {
  final AuthRepository _repository;

  LoginUser(this._repository);

  Future<Map<String, dynamic>?> call(String usernameOrEmail, String password) async {
    return await _repository.login(usernameOrEmail, password);
  }
}
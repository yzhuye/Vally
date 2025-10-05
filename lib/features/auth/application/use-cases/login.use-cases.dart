import 'package:vally_app/features/auth/domain/repositories/auth.repository.dart';
import 'package:vally_app/features/auth/application/dto/login.dto.dart';
import 'package:vally_app/features/auth/domain/entities/auth.dart';

class LoginUserCase {
  final AuthRepository _repository;

  LoginUserCase(this._repository);

  Future<Auth?> call(LoginDto dto) async {
    return await _repository.login(dto);
  }
}

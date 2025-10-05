import 'package:vally_app/features/auth/application/dto/login.dto.dart';
import 'package:vally_app/features/auth/domain/entities/auth.dart';

abstract class AuthRepository {
  Future<Auth?> login(LoginDto dto);
}

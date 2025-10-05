// features/auth/data/datasources/remote/auth_remote_datasource.dart
import 'package:vally_app/features/auth/application/dto/login.dto.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>?> login(LoginDto dto);
  Future<String?> refreshToken();
  Future<void> logout();
}

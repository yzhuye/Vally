// features/auth/data/repositories/auth_repository_impl.dart
import 'package:hive/hive.dart';
import 'package:vally_app/features/auth/application/dto/login.dto.dart';
import 'package:vally_app/features/auth/domain/entities/auth.dart';
import 'package:vally_app/features/auth/domain/repositories/auth.repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl({required this.remote});

  @override
  Future<Auth?> login(LoginDto dto) async {
    final response = await remote.login(dto);

    if (response != null && response["success"] == true) {
      return Auth(
        accessToken: response["accessToken"],
        refreshToken: response["refreshToken"],
      );
    }

    return null;
  }

  Future<Auth?> refreshToken(String refreshToken) async {
    final newAccessToken = await remote.refreshToken();
    if (newAccessToken != null) {
      return Auth(accessToken: newAccessToken, refreshToken: refreshToken);
    }
    return null;
  }

  Future<void> saveSession(Auth auth, bool rememberMe) async {
    if (rememberMe) {
      final loginBox = Hive.box('login');
      await loginBox.put('accessToken', auth.accessToken);
      await loginBox.put('refreshToken', auth.refreshToken);
    }
  }

  Future<void> saveUserSession(String email, Auth auth, bool rememberMe) async {
    if (rememberMe) {
      final loginBox = Hive.box('login');
      await loginBox.put('email', email);
      await loginBox.put('accessToken', auth.accessToken);
      await loginBox.put('refreshToken', auth.refreshToken);
    }
  }

  Future<Auth?> loadSession() async {
    // Retornar desde el local datasource (pendiente)
    return null;
  }

  Future<void> clearSession() async {
    await remote.logout();
  }
}

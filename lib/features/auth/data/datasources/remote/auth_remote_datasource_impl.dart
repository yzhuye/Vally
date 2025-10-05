// features/auth/data/datasources/remote/auth_remote_datasource_impl.dart
import 'package:vally_app/core/network/api_service.dart';
import 'package:vally_app/features/auth/application/dto/login.dto.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService _apiService;

  AuthRemoteDataSourceImpl(this._apiService);

  @override
  Future<Map<String, dynamic>?> login(LoginDto dto) async {
    final result = await ApiService.loginUser(
      dto.email,
      dto.password,
      dto.rememberMe,
    );
    return result;
  }

  @override
  Future<String?> refreshToken() async {
    return await ApiService.refreshAccessToken();
  }

  @override
  Future<void> logout() async {
    await ApiService.logout();
  }
}

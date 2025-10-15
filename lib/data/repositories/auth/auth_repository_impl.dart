import '../../../domain/repositories/auth_repository.dart';
import 'package:vally_app/data/datasources/remote/auth/api_service.dart';
import 'package:logger/logger.dart';

class AuthRepositoryImpl implements AuthRepository {
  static var logger = Logger();

  @override
  Future<Map<String, dynamic>?> login(
      String usernameOrEmail, String password, bool rememberMe) async {
    try {
      // Aquí es donde la capa de datos se conecta con tu servicio de API.
      final response =
          await ApiService.loginUser(usernameOrEmail, password, rememberMe);
      return response;
    } catch (e) {
      logger.e('Error en AuthRepositoryImpl: $e');
      return null;
    }
  }
}

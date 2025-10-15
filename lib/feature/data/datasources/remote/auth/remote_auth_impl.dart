import '../../auth_datasource.dart';
import 'package:vally_app/core/remote/api_service.dart';
import 'package:logger/logger.dart';

class RemoteAuthImpl implements AuthDataSource {
  static var logger = Logger();

  @override
  Future<Map<String, dynamic>?> login(
      String usernameOrEmail, String password, bool rememberMe) async {
    try {
      // Implementación para conectar con el servicio de API remoto
      final response =
          await ApiService.loginUser(usernameOrEmail, password, rememberMe);
      return response;
    } catch (e) {
      logger.e('Error en AuthRepositoryImpl: $e');
      return null;
    }
  }
}

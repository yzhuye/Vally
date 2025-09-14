import '../../../domain/repositories/auth_repository.dart';
import 'package:vally_app/domain/services/api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Map<String, dynamic>?> login(
      String usernameOrEmail, String password) async {
    try {
      // Aquí es donde la capa de datos se conecta con tu servicio de API.
      final response = await ApiService.loginUser(usernameOrEmail, password);
      return response;
    } catch (e) {
      print('Error en AuthRepositoryImpl: $e');
      return null;
    }
  }
}

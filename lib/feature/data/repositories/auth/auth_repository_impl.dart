import '../../../domain/repositories/auth_repository.dart';
import '../../datasources/auth_datasource.dart';
import '../../datasources/remote/auth/remote_auth_impl.dart';
import '../../datasources/in-memory/auth/in_memory_auth_impl.dart';
import 'package:logger/logger.dart';

class AuthRepositoryImpl implements AuthRepository {
  static var logger = Logger();

  // Selección del datasource
  late final AuthDataSource _authDataSource;

  AuthRepositoryImpl({bool useInMemory = false}) {
    // Ahora puedes elegir fácilmente entre datasources
    if (useInMemory) {
      _authDataSource = InMemoryAuthImpl();
      logger.i('Using InMemory AuthDataSource');
    } else {
      _authDataSource = RemoteAuthImpl();
      logger.i('Using Remote AuthDataSource');
    }
  }

  @override
  Future<Map<String, dynamic>?> login(
      String usernameOrEmail, String password, bool rememberMe) async {
    try {
      // Delega la lógica al datasource seleccionado
      final response =
          await _authDataSource.login(usernameOrEmail, password, rememberMe);
      return response;
    } catch (e) {
      logger.e('Error en AuthRepositoryImpl: $e');
      return null;
    }
  }
}

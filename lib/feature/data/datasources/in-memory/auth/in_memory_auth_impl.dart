import '../../auth_datasource.dart';

class InMemoryAuthImpl implements AuthDataSource {
  // Datos simulados para testing o modo offline
  static final Map<String, Map<String, dynamic>> _users = {
    'admin@test.com': {
      'password': 'admin123',
      'user': {
        'id': '1',
        'email': 'admin@test.com',
        'name': 'Admin User',
        'role': 'admin'
      }
    },
    'user@test.com': {
      'password': 'user123',
      'user': {
        'id': '2',
        'email': 'user@test.com',
        'name': 'Test User',
        'role': 'user'
      }
    }
  };

  @override
  Future<Map<String, dynamic>?> login(
      String usernameOrEmail, String password, bool rememberMe) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));

    final userData = _users[usernameOrEmail];

    if (userData != null && userData['password'] == password) {
      return {
        'success': true,
        'message': 'Login exitoso',
        'user': userData['user'],
        'accessToken':
            'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
        'refreshToken':
            'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}'
      };
    }

    return {'success': false, 'error': 'Credenciales incorrectas'};
  }
}

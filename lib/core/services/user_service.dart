import 'package:vally_app/core/remote/api_user_courses.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  // Cache para usuarios de la API
  Map<String, String> _userCache = {}; // email -> username
  bool _isLoaded = false;

  /// Carga todos los usuarios de la API
  Future<void> loadUsers() async {
    if (_isLoaded) return;

    try {
      print('🔍 DEBUG UserService - Loading users from API...');

      // Obtener todos los usuarios de la API
      final users = await ApiUserCourses.getAllUsers();
      print('🔍 DEBUG UserService - Raw API response: $users');

      final userMap = <String, String>{};
      for (var user in users) {
        final email = user["email"]?.toString().toLowerCase();
        final username = user["username"]?.toString();

        print(
            '🔍 DEBUG UserService - Processing user: email=$email, username=$username');

        if (email != null && username != null) {
          userMap[email] = username;
          print('🔍 DEBUG UserService - Loaded user: $email -> $username');
        } else {
          print(
              '🔍 DEBUG UserService - Skipping user due to null values: $user');
        }
      }

      _userCache = userMap;
      _isLoaded = true;
      print(
          '🔍 DEBUG UserService - Final cache loaded with ${userMap.length} users from API');
      print('🔍 DEBUG UserService - Final cache: $_userCache');
    } catch (e) {
      print('🔍 DEBUG UserService - Error loading users from API: $e');
      _userCache = {};
      _isLoaded = true; // Marcar como cargado para evitar reintentos
    }
  }

  /// Obtiene el nombre de usuario por email
  String? getUsernameByEmail(String email) {
    final emailLower = email.toLowerCase();
    return _userCache[emailLower];
  }

  /// Obtiene el email por nombre de usuario
  String? getEmailByUsername(String username) {
    final usernameLower = username.toLowerCase();
    for (var entry in _userCache.entries) {
      if (entry.value.toLowerCase() == usernameLower) {
        return entry.key;
      }
    }
    return null;
  }

  /// Limpia el cache (útil para testing o recargar datos)
  void clearCache() {
    _userCache.clear();
    _isLoaded = false;
  }

  /// Verifica si el cache está cargado
  bool get isLoaded => _isLoaded;

  /// Obtiene todos los usuarios del cache
  Map<String, String> get allUsers => Map.from(_userCache);
}

/// Servicio para mapear emails de usuarios autenticados a nombres usados en grupos
class EmailMappingService {
  static final Map<String, String> _emailMappings = {
    // Mapeos para usuarios de prueba - de email a nombre usado en grupos
    'gabriela@uninorte.edu.co': 'gabriela',
    'camila@uninorte.edu.co': 'camila',
    'daniela@uninorte.edu.co': 'daniela',
    'eliana@uninorte.edu.co': 'eliana',
    'fernanda@uninorte.edu.co': 'fernanda',
    
    // Betty: de email a nombre
    'b@a.com': 'betty',
  };

  /// Mapea el email del usuario autenticado al nombre usado en los grupos
  static String mapUserEmailToGroupEmail(String userEmail) {
    // Si hay un mapeo específico, usarlo; si no, usar el email original
    return _emailMappings[userEmail.toLowerCase()] ?? userEmail;
  }

  /// Agrega un nuevo mapeo de email
  static void addEmailMapping(String userEmail, String groupEmail) {
    _emailMappings[userEmail.toLowerCase()] = groupEmail;
  }

  /// Obtiene el mapeo inverso (de email de grupo a email de usuario)
  static String? getReverseMapping(String groupEmail) {
    for (final entry in _emailMappings.entries) {
      if (entry.value.toLowerCase() == groupEmail.toLowerCase()) {
        return entry.key;
      }
    }
    return null;
  }

  /// Obtiene todos los mapeos actuales
  static Map<String, String> getAllMappings() {
    return Map.from(_emailMappings);
  }

  /// Limpia todos los mapeos
  static void clearMappings() {
    _emailMappings.clear();
  }

}

// features/auth/presentation/controllers/login_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:vally_app/features/auth/application/use-cases/login.use-cases.dart';
import 'package:vally_app/features/auth/application/dto/login.dto.dart';
import 'package:vally_app/features/auth/domain/entities/auth.dart';
import 'package:vally_app/features/course/presentation/screens/home/home_screen.dart';

class LoginController extends GetxController {
  final LoginUserCase loginUser; // ← Inyectado desde los bindings
  final logger = Logger();

  // UI state
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
  var rememberMe = false.obs;

  // Output (para que la vista reaccione)
  var authResult = Rxn<Auth>();
  var errorMessage = RxnString();

  LoginController(this.loginUser);

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe(bool? value) {
    if (value != null) rememberMe.value = value;
  }

  Future<void> onLoginPressed() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = "Por favor, llena ambos campos.";
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final dto = LoginDto(
        email: email,
        password: password,
        rememberMe: rememberMe.value,
      );

      final result = await loginUser(dto);

      if (result != null) {
        authResult.value = result;
        logger.i("Login exitoso: ${result.accessToken}");

        // Guardar la sesión si "Remember Me" está marcado
        if (rememberMe.value) {
          await _saveUserSession(email, result);
        }

        // Navegar a la página de home después del login exitoso
        _navigateToHome();
      } else {
        errorMessage.value = "Credenciales inválidas o error en el servidor.";
        logger.e("Login fallido.");
      }
    } catch (e) {
      errorMessage.value = "Ocurrió un error inesperado.";
      logger.e("Error durante login: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Navegar a la página de home y inicializar el CourseController
  void _navigateToHome() {
    try {
      // Navegar a la página de home
      Get.offAll(() => const HomeScreen());

      logger.i("Navegación exitosa a la página de home");
    } catch (e) {
      logger.e("Error al navegar a home: $e");
      errorMessage.value = "Error al acceder a la aplicación";
    }
  }

  Future<void> _saveUserSession(String email, Auth auth) async {
    try {
      final loginBox = Hive.box('login');
      await loginBox.put('email', email);
      await loginBox.put('accessToken', auth.accessToken);
      await loginBox.put('refreshToken', auth.refreshToken);
    } catch (e) {
      logger.e("Error al guardar la sesión: $e");
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

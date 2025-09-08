import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:vally_app/app/domain/usecases/login/login_user.dart'; 
import 'package:vally_app/app/data/repositories/auth/auth_repository_impl.dart'; 
import 'package:vally_app/app/presentation/screens/home/home_screen.dart';

class LoginController extends GetxController {
  final LoginUser _loginUser = LoginUser(AuthRepositoryImpl());
  
  // Controladores y estado reactivo
  final usernameOrEmailController = TextEditingController();
  final passwordController = TextEditingController();
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
  
  static var logger = Logger();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (usernameOrEmailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Campos Vacíos',
        'Por favor, llena ambos campos.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      final response = await _loginUser(
        usernameOrEmailController.text,
        passwordController.text,
      );

      if (response != null && response["success"] == true) {
        logger.i("Login successful: $response");
        Get.snackbar(
          '¡Éxito!',
          'Login exitoso! 🎉',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAll(() => const HomeScreen());
      } else {
        String errorMessage = response?["error"] ?? "Error desconocido";
        logger.e("Login failed: $errorMessage");
        Get.snackbar(
          'Error',
          'Falló el inicio de sesión 😢\n$errorMessage',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      logger.e("An exception occurred during login: $e");
      Get.snackbar(
        'Error Inesperado',
        'Ocurrió un error. Inténtalo de nuevo.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameOrEmailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
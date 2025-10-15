import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vally_app/core/remote/api_service.dart';
import 'package:vally_app/feature/domain/usecases/login/login_user.dart';
import 'package:vally_app/feature/data/repositories/auth/auth_repository_impl.dart';
import 'package:vally_app/feature/presentation/screens/home_screen.dart';

class LoginController extends GetxController {
  final LoginUser _loginUser = LoginUser(AuthRepositoryImpl());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
  final isRememberMeChecked = false.obs;
  final Box loginBox = Hive.box('login');
  static const storage = FlutterSecureStorage();
  final ApiService apiService = ApiService();
  static var logger = Logger();

  @override
  void onInit() {
    super.onInit();
    _loadTokens();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe(bool? value) {
    if (value != null) {
      isRememberMeChecked.value = value;
    }
  }

  Future<void> login() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
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
        emailController.text,
        passwordController.text,
        isRememberMeChecked.value,
      );

      if (response != null && response["success"] == true) {
        logger.i("Login successful: $response");
        Get.snackbar(
          '¡Éxito!',
          'Login exitoso! 🎉',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        _saveLoginData(
          emailController.text,
          isRememberMeChecked.value,
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

  void _saveLoginData(String email, bool rememberMe) {
    loginBox.put('email', email);
    loginBox.put('rememberMe', rememberMe);
  }

  void _loadTokens() async {
    final rememberMe = loginBox.get('rememberMe', defaultValue: false);
    isRememberMeChecked.value = rememberMe;
    if (rememberMe) {
      final refreshToken = await storage.read(key: "refreshToken");
      if (refreshToken == null) return;
      ApiService.refreshAccessToken().then((newAccessToken) {
        if (newAccessToken != null) {
          logger.i("Access token refreshed successfully.");
          Get.offAll(() => const HomeScreen());
        } else {
          logger.w("Failed to refresh access token.");
        }
      });
    } else {
      await storage.delete(key: "accessToken");
      await storage.delete(key: "refreshToken");
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

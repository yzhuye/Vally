// features/auth/presentation/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vally_app/features/auth/presentation/widgets/login_button.dart';
import 'package:vally_app/features/auth/presentation/widgets/styled_text_field.dart';
import 'package:vally_app/features/auth/presentation/controller/login.controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inyectamos el controlador desde los bindings (no manualmente)
    final LoginController controller = Get.find<LoginController>();
    final size = MediaQuery.of(context).size;

    const Color darkTextColor = Color(0xFF1E2A38);
    const Color backgroundColor = Color(0xFFF5F9FF);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/vally_logo.png',
                    height: size.height * 0.15,
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Bienvenido de vuelta',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: darkTextColor,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Inicia sesión para continuar',
                    style: TextStyle(fontSize: 16.0, color: Colors.black54),
                  ),
                  const SizedBox(height: 40.0),

                  // Campo de correo
                  StyledTextField(
                    controller: controller.emailController,
                    hintText: 'Email',
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 20.0),

                  // Campo de contraseña
                  Obx(() => StyledTextField(
                        controller: controller.passwordController,
                        hintText: 'Contraseña',
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        isPasswordVisible: controller.isPasswordVisible.value,
                        onVisibilityToggle: controller.togglePasswordVisibility,
                      )),
                  const SizedBox(height: 20.0),

                  // Checkbox
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: controller.rememberMe.value,
                            onChanged: controller.toggleRememberMe,
                          ),
                          const Text(
                            'Mantener sesión iniciada',
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.black54),
                          ),
                        ],
                      )),
                  const SizedBox(height: 32.0),

                  // Botón de login
                  Obx(() => LoginButton(
                        isLoading: controller.isLoading.value,
                        onTap: controller.onLoginPressed,
                      )),

                  // Mostrar error en pantalla si existe
                  const SizedBox(height: 20),
                  Obx(() {
                    final error = controller.errorMessage.value;
                    if (error != null) {
                      return Text(
                        error,
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

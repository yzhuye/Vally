import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';
import 'package:vally_app/app/presentation/widgets/password_text_field.dart';
import 'package:vally_app/app/domain/services/api_service.dart';
import 'package:vally_app/app/presentation/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameOrEmailController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  static var logger = Logger();

  Future<void> login(context) async {
    final response = await ApiService.loginUser(
      usernameOrEmailController.text, // Can be either username or email
      passwordController.text,
    );

    if (response != null && response["success"] == true) {
      logger.i("Login successful: $response");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successful! 🎉'),
          backgroundColor: Colors.green,
        ),
      );

      Future.delayed(Duration(seconds: 2), () {
        Get.offAll(() => HomeScreen());
      });
    } else {
      logger.e("Login failed");
      // String errorMessage = response?["error"] ?? "Unknown error";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          //TODO: Replace with error message when backend is ready
          content: Text('Login failed 😢'), 
          //content: Text('Login failed 😢\n$errorMessage'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  static final ButtonStyle darkButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.blue, // Button color
    foregroundColor: Colors.white, // Text color
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    padding: EdgeInsets.symmetric(vertical: 16),
  );

  static final InputDecoration lightTextFieldStyle = InputDecoration(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 2), // Active color
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 2), // Default color
    ),
    hintStyle: TextStyle(color: Colors.grey),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
            /*
            // NOT IMPLEMENTED YET LOL
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, size: 25, color: Colors.blue),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/welcome',
                    (route) => false,
                  );
                },
              ),
            ),
            */
            SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Welcome Back!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: usernameOrEmailController,
                      decoration: lightTextFieldStyle.copyWith(
                        hintText: "Username or Email",
                        prefixIcon: Icon(Icons.person, color: Colors.blue),
                      ),
                    ),
                    SizedBox(height: 10),
                    PasswordTextField(
                      controller: passwordController,
                      decoration: lightTextFieldStyle,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        login(context);
                      },
                      style: darkButtonStyle,
                      child: Text("Log In", style: TextStyle(fontSize: 18)),
                    ),
                    SizedBox(height: 15),
                    /*
                    // NOT IMPLEMENTED YET LOL
                    GestureDetector(
                      onTap: () {
                        // Navigate to the login screen
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.blue),
                          children: [
                            TextSpan(
                              text: "Sign up",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    */
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

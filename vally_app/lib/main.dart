import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/presentation/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Vally',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true, 
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
      home: const LoginScreen(),
    );
  }
}
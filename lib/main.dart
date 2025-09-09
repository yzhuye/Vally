import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/presentation/screens/login/login_screen.dart';
import 'app/data/models/course_hive_model.dart';
import 'app/data/models/category_hive_model.dart';
import 'app/data/models/user_hive_model.dart'; // <-- nuevo
import 'app/domain/services/preload_data.dart'; // <-- nuevo

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // 🔹 Registrar adapters
  Hive.registerAdapter(CourseHiveModelAdapter());
  Hive.registerAdapter(CategoryHiveModelAdapter());
  Hive.registerAdapter(UserHiveModelAdapter()); // <-- nuevo

  // 🔹 Abrir boxes
  await Hive.openBox<CourseHiveModel>('courses');
  await Hive.openBox('categories');
  await Hive.openBox<UserHiveModel>('users'); // <-- nuevo
  await Hive.openBox('login');

  // 🔹 Precargar datos de prueba
  await preloadData();

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
      home: const LoginScreen(),
    );
  }
}

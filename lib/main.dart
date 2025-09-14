import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

import 'presentation/screens/login/login_screen.dart';
import 'data/models/course_hive_model.dart';
import 'data/models/category_hive_model.dart';
import 'data/models/user_hive_model.dart';
import 'data/models/group_hive_model.dart';
import 'domain/services/preload_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(CourseHiveModelAdapter());
  Hive.registerAdapter(CategoryHiveModelAdapter());
  Hive.registerAdapter(UserHiveModelAdapter());
  Hive.registerAdapter(GroupHiveModelAdapter());

  try {
    await Hive.deleteBoxFromDisk('courses');
    await Hive.deleteBoxFromDisk('users');
    await Hive.deleteBoxFromDisk('categories');
    await Hive.deleteBoxFromDisk('groups');
    await Hive.deleteBoxFromDisk('login');
  } catch (e) {
    Logger().e("Error deleting boxes: $e");
  }

  await Hive.openBox<CourseHiveModel>('courses');
  await Hive.openBox('categories');
  await Hive.openBox<UserHiveModel>('users');
  await Hive.openBox<GroupHiveModel>('groups');
  await Hive.openBox('login');

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

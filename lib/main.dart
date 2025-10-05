import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:vally_app/features/auth/presentation/bindings/auth_binding.dart';
import 'package:vally_app/features/auth/presentation/screens/login_screen.dart';

import 'features/course/data/models/course_hive_model.dart';
import 'features/course/data/models/category_hive_model.dart';
import 'features/course/data/models/user_hive_model.dart';
import 'features/course/data/models/group_hive_model.dart';
import 'features/course/data/models/activity_hive_model.dart';
import 'features/course/data/models/evaluation_hive_model.dart';
import 'core/local/preload_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(CourseHiveModelAdapter());
  Hive.registerAdapter(CategoryHiveModelAdapter());
  Hive.registerAdapter(UserHiveModelAdapter());
  Hive.registerAdapter(GroupHiveModelAdapter());
  Hive.registerAdapter(ActivityHiveModelAdapter());
  Hive.registerAdapter(EvaluationHiveModelAdapter());

  await Hive.openBox<CourseHiveModel>('courses');
  await Hive.openBox('categories');
  await Hive.openBox<UserHiveModel>('users');
  await Hive.openBox<GroupHiveModel>('groups');
  await Hive.openBox<ActivityHiveModel>('activities');
  await Hive.openBox<EvaluationHiveModel>('evaluations');
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
      initialBinding: AuthBinding(),
      home: const LoginScreen(),
    );
  }
}

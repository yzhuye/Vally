import 'package:hive/hive.dart';
import '../entities/course.dart';
import '../../data/models/activity_hive_model.dart';

class TestActivityData {
  static Future<void> createTestActivities({String? specificCategoryId}) async {
    try {
      final activityBox = Hive.box<ActivityHiveModel>('activities');
      
      print('🧪 Creating test activities...');
      print('📦 Current activities in box: ${activityBox.length}');
      
      List<String> categoryIds = [];
      
      if (specificCategoryId != null) {
        // Si se proporciona un ID específico, usarlo
        categoryIds = [specificCategoryId];
        print('🎯 Creating activities for specific category: $specificCategoryId');
      } else {
        // Crear actividades para múltiples categorías posibles
        categoryIds = [
          '1', '2', '3', // IDs numéricos simples
          'category_1', 'category_2', // IDs con prefijo
        ];
        print('🎯 Creating activities for multiple category IDs to ensure visibility');
      }
      
      int createdCount = 0;
      
      for (String categoryId in categoryIds) {
        // Crear actividades de prueba para cada categoría posible
        final testActivities = [
          Activity(
            id: 'activity_${categoryId}_1',
            name: 'Evaluación Sprint 1 - $categoryId',
            description: 'Evalúa el desempeño de tus compañeros en el primer sprint',
            dueDate: DateTime.now().add(const Duration(days: 3)),
            categoryId: categoryId,
          ),
          Activity(
            id: 'activity_${categoryId}_2',
            name: 'Evaluación Medio Término - $categoryId',
            description: 'Evaluación de medio término del proyecto',
            dueDate: DateTime.now().add(const Duration(days: 7)),
            categoryId: categoryId,
          ),
        ];
        
        // Guardar actividades en Hive
        for (final activity in testActivities) {
          final activityHive = ActivityHiveModel.fromActivity(activity);
          await activityBox.put(activity.id, activityHive);
          createdCount++;
          print('✅ Created: ${activity.name} for category $categoryId');
        }
      }
      
      print('🎉 Test activities created successfully!');
      print('📊 Created $createdCount activities total');
      print('📊 Total activities in box: ${activityBox.length}');
      
    } catch (e) {
      print('💥 Error creating test activities: $e');
    }
  }
  
  static Future<void> listAllActivities() async {
    try {
      final activityBox = Hive.box<ActivityHiveModel>('activities');
      print('📋 All activities in database:');
      print('   Total count: ${activityBox.length}');
      
      for (final activityHive in activityBox.values) {
        print('   - ${activityHive.name} (Category: ${activityHive.categoryId})');
      }
      
      if (activityBox.isEmpty) {
        print('   (No activities found)');
      }
    } catch (e) {
      print('💥 Error listing activities: $e');
    }
  }
}

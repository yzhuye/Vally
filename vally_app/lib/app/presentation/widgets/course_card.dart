import 'package:flutter/material.dart';
import '../../domain/entities/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      color: Colors.white,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Image.asset(course.imageUrl,
              height: 120, width: double.infinity, fit: BoxFit.cover)),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              course.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
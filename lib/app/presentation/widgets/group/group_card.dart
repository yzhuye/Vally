import 'package:flutter/material.dart';
import '../../../domain/entities/course.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback onJoin;

  const GroupCard({
    super.key,
    required this.group,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.transparent),
        ),
        collapsedShape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.transparent),
        ),
        leading: const Icon(Icons.group),
        title: Text(group.name),
        subtitle: Text("Integrantes: ${group.capacityText}"),
        children: [
          ...group.members.map(
            (name) => Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(name),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: group.isFull ? null : onJoin,
                  child: Text(group.status),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

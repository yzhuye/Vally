import 'package:flutter/material.dart';
import '../../../domain/entities/course.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback onJoin;
  final String? currentUserEmail;
  final bool? canJoin;
  final String Function(String)? nameMapper;

  const GroupCard({
    super.key,
    required this.group,
    required this.onJoin,
    this.currentUserEmail,
    this.canJoin,
    this.nameMapper,
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
        leading: CircleAvatar(
          backgroundColor:
              group.isFull ? Colors.green : const Color(0xFF00A4BD),
          child: Text(
            '${group.members.length}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                group.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (group.isFull)
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 20,
              )
            else
              const Icon(
                Icons.person_add,
                color: Color(0xFF00A4BD),
                size: 20,
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Integrantes: ${group.capacityText}"),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: group.members.length / group.maxCapacity,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                group.isFull ? Colors.green : const Color(0xFF00A4BD),
              ),
            ),
          ],
        ),
        children: [
          if (group.members.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Miembros:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...group.members.map(
              (member) {
                final isCurrentUser =
                    currentUserEmail != null && member == currentUserEmail;
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCurrentUser
                            ? const Color(0xFF00A4BD).withAlpha(25)
                            : Colors.grey.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                        border: isCurrentUser
                            ? Border.all(
                                color: const Color(0xFF00A4BD).withAlpha(76))
                            : null,
                      ),
                      child: Text(
                        isCurrentUser
                            ? '${nameMapper?.call(member) ?? member} (Tú)'
                            : nameMapper?.call(member) ?? member,
                        style: TextStyle(
                          color: isCurrentUser
                              ? const Color(0xFF00A4BD)
                              : Colors.black87,
                          fontWeight: isCurrentUser
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ] else ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'No hay miembros en este grupo',
                style:
                    TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 150,
                child: ElevatedButton.icon(
                  onPressed: _getButtonEnabled() ? onJoin : null,
                  icon: Icon(_getButtonIcon()),
                  label: Text(_getButtonText()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getButtonColor(),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _getButtonEnabled() {
    if (currentUserEmail == null) return false;

    final isCurrentUser = group.members.contains(currentUserEmail);
    if (isCurrentUser)
      return false; // Los estudiantes ya en el grupo no pueden hacer nada

    if (group.isFull) return false;

    return canJoin ?? true;
  }

  IconData _getButtonIcon() {
    if (currentUserEmail == null) return Icons.block;

    final isCurrentUser = group.members.contains(currentUserEmail);
    if (isCurrentUser) return Icons.check_circle;

    if (group.isFull) return Icons.block;

    return Icons.person_add;
  }

  String _getButtonText() {
    if (currentUserEmail == null) return 'No disponible';

    final isCurrentUser = group.members.contains(currentUserEmail);
    if (isCurrentUser) return 'En este grupo';

    if (group.isFull) return 'Lleno';

    if (canJoin == false) return 'Ya en grupo';

    return 'Unirse';
  }

  Color _getButtonColor() {
    if (currentUserEmail == null) return Colors.grey;

    final isCurrentUser = group.members.contains(currentUserEmail);
    if (isCurrentUser) return Colors.green;

    if (group.isFull || canJoin == false) return Colors.grey;

    return const Color(0xFF00A4BD);
  }
}

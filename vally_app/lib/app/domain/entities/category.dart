class Category {
  final String id;
  String name;
  String groupingMethod; // "random" | "self-assigned" | "manual"
  int groupCount;
  int studentsPerGroup;

  Category({
    required this.id,
    required this.name,
    required this.groupingMethod,
    required this.groupCount,
    required this.studentsPerGroup,
  });
}

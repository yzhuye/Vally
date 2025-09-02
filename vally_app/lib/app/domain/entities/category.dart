class Category {
  final String id;
  String name;
  String groupingMethod; // "random" | "self-assigned" | "manual"

  Category({
    required this.id,
    required this.name,
    required this.groupingMethod,
  });
}

class GroceryTitleModel {
  final String id;
  final String title;
  String? createdAt;

  GroceryTitleModel({
    required this.id,
    required this.title,
    this.createdAt,
  });

  factory GroceryTitleModel.fromJson(Map<String, dynamic> json) {
    return GroceryTitleModel(
      id: json['id'],
      title: json['title'],
      createdAt: json['createdAt'],
    );
  }
}

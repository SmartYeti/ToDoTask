class UpdateTitleGroceryModel {
  final String id;
  final String title;
  String? updatedAt;

  UpdateTitleGroceryModel({
    required this.id,
    required this.title,
    this.updatedAt,
  });
}

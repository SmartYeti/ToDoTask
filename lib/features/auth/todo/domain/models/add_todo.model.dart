class AddTodoModel {
  final String title;
  final String description;
  final String? userId;

  AddTodoModel({required this.title, required this.description, this.userId});
}

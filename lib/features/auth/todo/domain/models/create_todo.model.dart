class TodoModel {
  final String id;
  final String title;
  final String description;
  bool isChecked;

  TodoModel(
      {required this.id,
      required this.title,
      required this.description,
      this.isChecked = false,
      });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isChecked: json['isChecked']
    );
  }
}

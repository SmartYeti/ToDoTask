class AuthUserModel {
  final String userId;
  final String email;
  final String firstName;
  final String lastName;

  AuthUserModel(
      {
      required this.userId,
      required this.email,
      required this.firstName,
      required this.lastName
      }
    );

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
        userId: json['userId'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName']);
  }
}

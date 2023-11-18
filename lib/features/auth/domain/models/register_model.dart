class RegisterModel {
  final String email;
  final String password;
  final String confirmPassword;
  final String firstName;
  final String lastName;

  RegisterModel({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.firstName,
    required this.lastName
  });
}

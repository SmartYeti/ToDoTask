part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthAutoLoginEvent extends AuthEvent {
}

class AuthLoginEvent extends AuthEvent {
  final LoginModel logInModel;

  AuthLoginEvent({
    required this.logInModel,
  });
}

class AuthRegisterEvent extends AuthEvent {
  final RegisterModel registerModel;

  AuthRegisterEvent({
    required this.registerModel,
  });
}

// class AuthGetUserEvent extends AuthEvent {
  
// }

class AuthLogoutEvent extends AuthEvent {
  
}

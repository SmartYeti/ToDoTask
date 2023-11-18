part of 'auth_bloc.dart';

@immutable
class AuthState {
  final StateStatus stateStatus;
  final String? errorMessage;
  final AuthUserModel? authUserModel;

  const AuthState({
    required this.stateStatus,
    this.errorMessage,
    this.authUserModel,
  });

  factory AuthState.initial() => const AuthState(
        stateStatus: StateStatus.initial,
      );

  AuthState copyWith({
    StateStatus? stateStatus,
    String? errorMessage,
    AuthUserModel? authUserModel,
  }) {
    return AuthState(
      stateStatus: stateStatus ?? this.stateStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      authUserModel: authUserModel ?? this.authUserModel,
    );
  }
}

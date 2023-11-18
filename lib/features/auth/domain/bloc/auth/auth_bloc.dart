import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:todo_list/core/enum/state_status.enum.dart';
import 'package:todo_list/features/auth/data/repository/auth_repository.dart';
import 'package:todo_list/features/auth/domain/models/auth_user.model.dart';
import 'package:todo_list/features/auth/domain/models/login_model.dart';
import 'package:todo_list/features/auth/domain/models/register_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthRepository authRepository) : super(AuthState.initial()) {
    on<AuthAutoLoginEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, AuthUserModel?> result =
          await authRepository.autoLogin();

      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));
      }, (userModel) {
        emit(state.copyWith(
            stateStatus: StateStatus.loaded, authUserModel: userModel));
      });
    });
    //get the user
    // on<AuthGetUserEvent>((event, emit) async {
    //   emit(state.copyWith(stateStatus: StateStatus.loading));
    //   final Either<String, AuthUserModel?> result =
    //       await authRepository.getUser();

    //   result.fold((error) {
    //     emit(state.copyWith(stateStatus: StateStatus.loading));
    //     emit(state.copyWith(
    //         stateStatus: StateStatus.error, errorMessage: error));
    //   }, (userModel) {
    //     emit(state.copyWith(
    //         stateStatus: StateStatus.loaded, authUserModel: userModel));
    //   });
    // });

    on<AuthLoginEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, AuthUserModel> result =
          await authRepository.login(event.logInModel);

      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));

        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (userModel) {
        emit(state.copyWith(
          stateStatus: StateStatus.loaded,
          authUserModel: userModel,
        ));
      });
    });
    on<AuthRegisterEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, AuthUserModel> result =
          await authRepository.register(event.registerModel);

      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));

        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (userModel) {
        emit(state.copyWith(
          stateStatus: StateStatus.loaded,
          authUserModel: userModel,
        ));
      });
    });

    on<AuthLogoutEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, Unit> result = await authRepository.logout();

      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (success) {
        emit(AuthState.initial());
      });
    });
  }
}

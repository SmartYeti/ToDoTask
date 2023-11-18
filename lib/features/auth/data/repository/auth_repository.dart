// ignore_for_file: avoid_print

import 'package:appwrite/models.dart';
import 'package:dartz/dartz.dart';
import 'package:todo_list/features/auth/data/datasource/auth_local.datasource.dart';
import 'package:todo_list/features/auth/data/datasource/auth_remote.datasource.dart';
import 'package:todo_list/features/auth/domain/models/auth_user.model.dart';
import 'package:todo_list/features/auth/domain/models/login_model.dart';
import 'package:todo_list/features/auth/domain/models/register_model.dart';

class AuthRepository {
  late AuthRemoteDatasoure _remoteDatasoure;
  late AuthLocalDatasource _authlocalDatasource;

  AuthRepository(
    AuthRemoteDatasoure remoteDatasoure,
    AuthLocalDatasource localDatasource,
  ) {
    _remoteDatasoure = remoteDatasoure;
    _authlocalDatasource = localDatasource;
  }

  Future<Either<String, AuthUserModel>> login(LoginModel loginModel) async {
    try {
      //Login using the model
      final Session session = await _remoteDatasoure.login(loginModel);

      //todo: should pass user id
      //Save session id
      _authlocalDatasource.saveSessionId(session.$id);

      //Get Auth user
      final AuthUserModel authUserModel =
          await _remoteDatasoure.getAuthUser(session.userId);

      //return Auth user
      return Right(authUserModel);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, AuthUserModel>> register(
      RegisterModel registerModel) async {
    try {
      //First Create account for Login
      await _remoteDatasoure.createAccount(registerModel);

      //Todo: Get session from appwrite
      //Login to get userId
      final Session session = await _remoteDatasoure.login(LoginModel(
          email: registerModel.email, password: registerModel.password));

      // should pass user id
      //Save session id
      _authlocalDatasource.saveSessionId(session.$id);

      //Todo: Pass the user ID from session
      //Save User Data to database
      await _remoteDatasoure.saveAccount(session.userId, registerModel);

      //get User Data

      final AuthUserModel authUserModel =
          await _remoteDatasoure.getAuthUser(session.userId);

      //return AuthUserModel
      return Right(authUserModel);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, AuthUserModel?>> autoLogin() async {
    try {
      //Get session id from Local datasource
      final String? sessionId = await _authlocalDatasource.getSessionId();

      //if null return Right(null)
      if (sessionId == null) return const Right(null);

      //else getSession
      final Session session = await _remoteDatasoure.getSessionId(sessionId);

      // should pass user id
      //get User Data
      final AuthUserModel authUserModel =
          await _remoteDatasoure.getAuthUser(session.userId);

      //return Auth User Model
      return Right(authUserModel);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Unit>> logout() async {
    try {
      final String? sessionId = await _authlocalDatasource.getSessionId();

      if (sessionId != null) {
        await _remoteDatasoure.deleteSession(sessionId);
        await _authlocalDatasource.deleteSession();
      }

      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }
}

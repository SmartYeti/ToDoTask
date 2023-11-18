import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:dartz/dartz.dart';
import 'package:todo_list/features/auth/domain/models/auth_user.model.dart';
import 'package:todo_list/features/auth/domain/models/login_model.dart';
import 'package:todo_list/features/auth/domain/models/register_model.dart';
import 'package:todo_list/config.dart';

class AuthRemoteDatasoure {
  late Account _account;
  late Databases _databases;
  AuthRemoteDatasoure(Account account, Databases databases) {
    _account = account;
    _databases = databases;
  }

  Future<Unit> createAccount(RegisterModel registerModel) async {
    await _account.create(
        userId: ID.unique(),
        email: registerModel.email,
        password: registerModel.password);

    return unit;
  }

  Future<Unit> saveAccount(String userId, RegisterModel registerModel) async {
    await _databases.createDocument(
        databaseId: Config.userdbId,
        collectionId: Config.userDetailsId,
        documentId: userId,
        data: {
          'userId': userId,
          'firstName': registerModel.firstName,
          'lastName': registerModel.lastName,
          'email': registerModel.email,
          'createdAt': DateTime.now().toIso8601String(),
          'updateAt': DateTime.now().toIso8601String()
        });

    return unit;
  }

  // return SESSION from appwrite
  Future<Session> login(LoginModel loginModel) async {
    final session = await _account.createEmailSession(
        email: loginModel.email, password: loginModel.password);

    return session;
  }

  Future<AuthUserModel> getAuthUser(String userId) async {
    final documents = await _databases.getDocument(
        databaseId: Config.userdbId,
        collectionId: Config.userDetailsId,
        documentId: userId);

    return AuthUserModel.fromJson(documents.data);
  }

  Future<Session> getSessionId(String sessionId) async {
    final Session session = await _account.getSession(sessionId: sessionId);

    return session;
  }

  Future<Unit> deleteSession(String sessionId) async {
    await _account.deleteSession(sessionId: sessionId);

    return unit;
  }
}

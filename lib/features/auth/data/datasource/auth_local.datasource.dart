import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todo_list/config.dart';

class AuthLocalDatasource {
  late FlutterSecureStorage _secureStorage;
  AuthLocalDatasource(FlutterSecureStorage secureStorage) {
    _secureStorage = secureStorage;
  }

  Future<Unit> saveSessionId(String sessionId) async {
    await _secureStorage.write(key: Config.sessionIdKey, value: sessionId);
    return unit;
  }

  Future<String?> getSessionId() async {
    return _secureStorage.read(key: Config.sessionIdKey);
  }

  Future<String?> getUserId() async {
    return _secureStorage.read(key: Config.userdbId);
  }

  Future<Unit> deleteSession() async {
    _secureStorage.delete(key: Config.sessionIdKey);
    return unit;
  }
}

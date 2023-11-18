import 'package:appwrite/appwrite.dart';
import 'package:dartz/dartz.dart';
import 'package:todo_list/config.dart';
import 'package:todo_list/features/auth/todo/domain/models/add_todo.model.dart';
import 'package:todo_list/features/auth/todo/domain/models/check_model.dart';
import 'package:todo_list/features/auth/todo/domain/models/create_todo.model.dart';
import 'package:todo_list/features/auth/todo/domain/models/delete.model.dart';
import 'package:todo_list/features/auth/todo/domain/models/update_todo.models.dart';

class TodoRemoteDatasource {
  late Databases _databases;

  TodoRemoteDatasource(Databases databases) {
    _databases = databases;
  }

  Future<String> addTask(AddTodoModel addtodoModel) async {
    final String taskId = ID.unique();
    final docs = await _databases.createDocument(
        databaseId: Config.userdbId,
        collectionId: Config.todoTitleID,
        documentId: taskId,
        data: {
          'id': taskId,
          'title': addtodoModel.title,
          'description': addtodoModel.description,
          'userId': addtodoModel.userId,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String()
        });

    return docs.$id;
  }

  Future<List<TodoModel>> getTask(String userId) async {
    final docs = await _databases.listDocuments(
      databaseId: Config.userdbId,
      collectionId: Config.todoTitleID,
      queries: [
        Query.equal('userId', userId)
      ]
    );

    return docs.documents
        .map((e) => TodoModel.fromJson({...e.data, 'id': e.$id}))
        .toList();
  }

  Future<Unit> deleteTask(DeleteTaskModel deleteTaskModel) async {
    await _databases.deleteDocument(
        databaseId: Config.userdbId,
        collectionId: Config.todoTitleID,
        documentId: deleteTaskModel.id);

    return unit;
  }

  Future<String> updateTodoModel(UpdateTodoModel updateTodoModel) async {
    final doc = await _databases.updateDocument(
        databaseId: Config.userdbId,
        collectionId: Config.todoTitleID,
        documentId: updateTodoModel.id,
        data: {
          'id': updateTodoModel.id,
          'title': updateTodoModel.title,
          'description': updateTodoModel.description,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String()
        });

    return doc.$id;
  }

  Future<String> checkTodoModel(CheckTodoModel checkTodoModel) async {
    final doc = await _databases.updateDocument(
        databaseId: Config.userdbId,
        collectionId: Config.todoTitleID,
        documentId: checkTodoModel.id,
        data: {'id': checkTodoModel.id, 'isChecked': checkTodoModel.isChecked});
    return doc.$id;
  }
}

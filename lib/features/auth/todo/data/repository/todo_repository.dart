import 'package:dartz/dartz.dart';
import 'package:todo_list/features/auth/todo/data/datasource/todo_remote.datasource.dart';
import 'package:todo_list/features/auth/todo/domain/models/add_todo.model.dart';
import 'package:todo_list/features/auth/todo/domain/models/check_model.dart';
import 'package:todo_list/features/auth/todo/domain/models/create_todo.model.dart';
import 'package:todo_list/features/auth/todo/domain/models/delete.model.dart';
import 'package:todo_list/features/auth/todo/domain/models/update_todo.models.dart';

class TodoRepository {
  late TodoRemoteDatasource _todoRemoteDatesource;

  TodoRepository(
    TodoRemoteDatasource remoteDatasource,
  ) {
    _todoRemoteDatesource = remoteDatasource;
  }

  Future<Either<String, String>> addTaskRepo(AddTodoModel addtodoModel) async {
    try {
      final result = await _todoRemoteDatesource.addTask(addtodoModel);

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> updateTaskRepo(
      UpdateTodoModel updateTodoModel) async {
    try {
      final result =
          await _todoRemoteDatesource.updateTodoModel(updateTodoModel);

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<TodoModel>>> getTaskRepo(String userId) async {
    try {
      final result = await _todoRemoteDatesource.getTask(userId);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Unit>> deleteTaskRepo(
      DeleteTaskModel deleteTaskModel) async {
    try {
      final result = await _todoRemoteDatesource.deleteTask(deleteTaskModel);

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Unit>> checkTaskRepo(
      CheckTodoModel checkTodoModel) async {
    try {
    await _todoRemoteDatesource.checkTodoModel(checkTodoModel);

      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }
}

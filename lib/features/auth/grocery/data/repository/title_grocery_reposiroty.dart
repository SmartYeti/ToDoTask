import 'package:dartz/dartz.dart';
import 'package:todo_list/features/auth/grocery/data/datasource/title_grocery_remote.Datasource.dart';
import 'package:todo_list/features/auth/grocery/domain/grocery_title.models/add_title.model.dart';
import 'package:todo_list/features/auth/grocery/domain/grocery_title.models/delete_title.model.dart';
import 'package:todo_list/features/auth/grocery/domain/grocery_title.models/grocery_title.model.dart';
import 'package:todo_list/features/auth/grocery/domain/grocery_title.models/update_title.model.dart';

class TitleGroceryRepository {
  late TitleGroceryRemoteDatasource _titleGroceryRemoteDatasource;

  TitleGroceryRepository(TitleGroceryRemoteDatasource remoteDatasource) {
    _titleGroceryRemoteDatasource = remoteDatasource;
  }

  Future<Either<String, String>> addTitleGroceryRepo(
      AddTitleGroceryModel addTitleGroceryModel) async {
    try {
      final result = await _titleGroceryRemoteDatasource
          .addTitleGrocery(addTitleGroceryModel);

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> updateTitleGroceryRepo(
      UpdateTitleGroceryModel updateTitleGroceryModel) async {
    try {
      final result = await _titleGroceryRemoteDatasource
          .updateTitleGrocery(updateTitleGroceryModel);

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<GroceryTitleModel>>> getTitleGroceryRepo(String userId) async {
    try {
      final result = await _titleGroceryRemoteDatasource.getTitleGrocery(userId);

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Unit>> deleteTitleGroceryRepo(
      DeleteTitleGroceryModel deleteTitleGroceryModel) async {
    try {
      final result = await _titleGroceryRemoteDatasource
          .deleteTitleGrocery(deleteTitleGroceryModel);

      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}

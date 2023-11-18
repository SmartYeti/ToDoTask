import 'package:dartz/dartz.dart';
import 'package:todo_list/features/auth/grocery/data/datasource/grocery_remote.datesource.dart';
import 'package:todo_list/features/auth/grocery/domain/models/add_grocery.model.dart';
import 'package:todo_list/features/auth/grocery/domain/models/delete_grocery.model.dart';
import 'package:todo_list/features/auth/grocery/domain/models/grocery.model.dart';
import 'package:todo_list/features/auth/grocery/domain/models/update_grocery.model.dart';

class GroceryRepository {
  late GroceryRemoteDatasource _groceryRemoteDatasource;

  GroceryRepository(
    GroceryRemoteDatasource remoteDatasource,
  ) {
    _groceryRemoteDatasource = remoteDatasource;
  }

  Future<Either<String, String>> addGroceryRepo(
      AddGroceryModel addGroceryModel) async {
    try {
      final result = await _groceryRemoteDatasource.addGrocery(addGroceryModel);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> updateGroceryRepo(
      UpdateGroceryModel updateGroceryModel) async {
    try {
      final result =
          await _groceryRemoteDatasource.updateGrocery(updateGroceryModel);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<GroceryItemModel>>> getGroceryRepo(String titleId) async {
    try {
      final result = await _groceryRemoteDatasource.getGrocery(titleId);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Unit>> deleteGroceryRepo(
      DeleteGroceryModel deleteGroceryModel) async {
    try {
      final result =
          await _groceryRemoteDatasource.deleteGrocery(deleteGroceryModel,);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}

import 'package:appwrite/appwrite.dart';
import 'package:dartz/dartz.dart';
import 'package:todo_list/config.dart';
import 'package:todo_list/features/auth/grocery/domain/models/add_grocery.model.dart';
import 'package:todo_list/features/auth/grocery/domain/models/delete_grocery.model.dart';
import 'package:todo_list/features/auth/grocery/domain/models/grocery.model.dart';
import 'package:todo_list/features/auth/grocery/domain/models/update_grocery.model.dart';

class GroceryRemoteDatasource {
  late Databases _databases;

  GroceryRemoteDatasource(Databases databases) {
    _databases = databases;
  }

  Future<String> addGrocery(AddGroceryModel addGroceryModel) async {
    final String groceryId = ID.unique();
    final docs = await _databases.createDocument(
      databaseId: Config.userdbId,
      collectionId: Config.grocerydbId,
      documentId: groceryId,
      data: {
        'id': groceryId,
        'productName': addGroceryModel.productName,
        'quantity': addGroceryModel.quantity,
        'price': addGroceryModel.price,
        'titleId': addGroceryModel.titleId,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
    return docs.$id;
  }

  Future<List<GroceryItemModel>> getGrocery(String titleId) async {
    final docs = await _databases.listDocuments(
        databaseId: Config.userdbId,
        collectionId: Config.grocerydbId,
        queries: [
          Query.equal('titleId', titleId)
        ]);
    return docs.documents
        .map((e) => GroceryItemModel.fromJson({...e.data, 'id': e.$id}))
        .toList();
  }

  Future<Unit> deleteGrocery(DeleteGroceryModel deleteGroceryModel) async {
    await _databases.deleteDocument(
      databaseId: Config.userdbId,
      collectionId: Config.grocerydbId,
      documentId: deleteGroceryModel.id,
    );
    return unit;
  }

  Future<String> updateGrocery(UpdateGroceryModel updateGroceryModel) async {
    final docs = await _databases.updateDocument(
        databaseId: Config.userdbId,
        collectionId: Config.grocerydbId,
        documentId: updateGroceryModel.id,
        data: {
          'id': updateGroceryModel.id,
          'productName': updateGroceryModel.productName,
          'quantity': updateGroceryModel.quantity,
          'price': updateGroceryModel.price,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });
    return docs.$id;
  }
}

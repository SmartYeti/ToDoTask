import 'package:appwrite/appwrite.dart';
import 'package:dartz/dartz.dart';
import 'package:todo_list/config.dart';
import 'package:todo_list/features/auth/grocery/domain/grocery_title.models/add_title.model.dart';
import 'package:todo_list/features/auth/grocery/domain/grocery_title.models/delete_title.model.dart';
import 'package:todo_list/features/auth/grocery/domain/grocery_title.models/grocery_title.model.dart';
import 'package:todo_list/features/auth/grocery/domain/grocery_title.models/update_title.model.dart';

class TitleGroceryRemoteDatasource {
  late Databases _databases;

  TitleGroceryRemoteDatasource(Databases databases) {
    _databases = databases;
  }

  Future<String> addTitleGrocery(
      AddTitleGroceryModel addTitleGroceryModel) async {
    final String titleGrocery = ID.unique();
    final docs = await _databases.createDocument(
      databaseId: Config.userdbId,
      collectionId: Config.titleGrocerydbId,
      documentId: titleGrocery,
      data: {
        'id': titleGrocery,
        'title': addTitleGroceryModel.title,
        'userId': addTitleGroceryModel.userId,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
    return docs.$id;
  }

  Future<List<GroceryTitleModel>> getTitleGrocery(String userId) async {
    final docs = await _databases.listDocuments(
      databaseId: Config.userdbId,
      collectionId: Config.titleGrocerydbId,
      queries: [
        Query.equal('userId', userId)
      ]
    );

    return docs.documents
        .map((e) => GroceryTitleModel.fromJson({...e.data, 'id': e.$id}))
        .toList();
  }

  Future<Unit> deleteTitleGrocery(
      DeleteTitleGroceryModel deleteTitleGrocery) async {
    await _databases.deleteDocument(
      databaseId: Config.userdbId,
      collectionId: Config.titleGrocerydbId,
      documentId: deleteTitleGrocery.id,
    );
    return unit;
  }

  Future<String> updateTitleGrocery(
      UpdateTitleGroceryModel updateTitleGroceryModel) async {
    final docs = await _databases.updateDocument(
        databaseId: Config.userdbId,
        collectionId: Config.titleGrocerydbId,
        documentId: updateTitleGroceryModel.id,
        data: {
          'id': updateTitleGroceryModel.id,
          'title': updateTitleGroceryModel.title,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        });
    return docs.$id;
  }
}

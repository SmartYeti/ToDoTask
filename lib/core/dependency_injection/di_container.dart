import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todo_list/features/auth/data/datasource/auth_local.datasource.dart';
import 'package:todo_list/features/auth/data/datasource/auth_remote.datasource.dart';
import 'package:todo_list/features/auth/data/repository/auth_repository.dart';
import 'package:todo_list/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:appwrite/appwrite.dart';
import 'package:todo_list/config.dart';
import 'package:todo_list/features/auth/grocery/data/datasource/grocery_remote.datesource.dart';
import 'package:todo_list/features/auth/grocery/data/datasource/title_grocery_remote.Datasource.dart';
import 'package:todo_list/features/auth/grocery/data/repository/grocery_repository.dart';
import 'package:todo_list/features/auth/grocery/data/repository/title_grocery_reposiroty.dart';
import 'package:todo_list/features/auth/grocery/domain/grocery_bloc/grocery_bloc.dart';
import 'package:todo_list/features/auth/grocery/domain/title_grocery_bloc/title_grocery_bloc.dart';
import 'package:todo_list/features/auth/todo/data/datasource/todo_remote.datasource.dart';
import 'package:todo_list/features/auth/todo/data/repository/todo_repository.dart';
import 'package:todo_list/features/auth/todo/domain/todo_bloc/todo_bloc.dart';

class DIContainer {
  ///core
  Client get _client => Client()
      .setEndpoint(Config.endpoint)
      .setProject(Config.projectId)
      .setSelfSigned(status: true);

  Account get _account => Account(_client);

  Databases get _databases => Databases(_client);

  FlutterSecureStorage get _secureStorage => const FlutterSecureStorage();

  //Local Datasoure
  AuthLocalDatasource get _authLocalDatasource =>
      AuthLocalDatasource(_secureStorage);
  //Remote Datasoure
  AuthRemoteDatasoure get _authRemoteDatasoure =>
      AuthRemoteDatasoure(_account, _databases);

  //TodoRemoteDatasource
  TodoRemoteDatasource get _todoRemoteDatasource =>
      TodoRemoteDatasource(_databases);

  // Gikan Remote ipasa sa repository
  //GroceryRemoteDatasource
  GroceryRemoteDatasource get _groceryRemoteDatasource =>
      GroceryRemoteDatasource(_databases);

  //titleGrocery
  TitleGroceryRemoteDatasource get _titleGroceryRemoteDatasource =>
      TitleGroceryRemoteDatasource(_databases);

  //Repository
  AuthRepository get _authRepository =>
      AuthRepository(_authRemoteDatasoure, _authLocalDatasource);

  //TodoRepository
  TodoRepository get _todoRepository => TodoRepository(_todoRemoteDatasource);

  //Kuha sa remote pasa adto sa bloc para ma basa ang value
  GroceryRepository get _groceryRepository =>
      GroceryRepository(_groceryRemoteDatasource);

  TitleGroceryRepository get _titleGroceryRepository =>
      TitleGroceryRepository(_titleGroceryRemoteDatasource);

  //Bloc
  AuthBloc get authBloc => AuthBloc(_authRepository);

  //TodoBLoc
  TodoBloc get todoBloc => TodoBloc(_todoRepository);

  GroceryItemBloc get groceryItemBloc => GroceryItemBloc(_groceryRepository);

  TitleGroceryBloc get titleGroceryBloc =>
      TitleGroceryBloc(_titleGroceryRepository);
}

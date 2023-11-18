part of 'title_grocery_bloc.dart';

@immutable
sealed class TitleGroceryEvent {}

class AddTitleGroceryEvent extends TitleGroceryEvent {
  final AddTitleGroceryModel addTitleGroceryModel;

  AddTitleGroceryEvent({required this.addTitleGroceryModel});
}

class UpdateTitleGroceryEvent extends TitleGroceryEvent {
  final UpdateTitleGroceryModel updateTitleGroceryModel;

  UpdateTitleGroceryEvent({required this.updateTitleGroceryModel});
}

class DeleteTitleGroceryEvent extends TitleGroceryEvent {
  final DeleteTitleGroceryModel deleteTitleGroceryModel;

  DeleteTitleGroceryEvent({required this.deleteTitleGroceryModel});
}

class GetTitleGroceryEvent extends TitleGroceryEvent {
  final String? userId;

  GetTitleGroceryEvent({
    this.userId,
  });
}

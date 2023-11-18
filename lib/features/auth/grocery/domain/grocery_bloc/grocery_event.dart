part of 'grocery_bloc.dart';

@immutable
sealed class GroceryItemEvent {}

class AddGroceryEvent extends GroceryItemEvent {
  final AddGroceryModel addGroceryModel;

  AddGroceryEvent({required this.addGroceryModel});
}

class UpdateGroceryEvent extends GroceryItemEvent {
  final UpdateGroceryModel updateGroceryModel;

  UpdateGroceryEvent({
    required this.updateGroceryModel,
  });
}

class DeleteGroceryEvent extends GroceryItemEvent {
  final DeleteGroceryModel deleteGroceryModel;

  DeleteGroceryEvent({
    required this.deleteGroceryModel,
  });
}

class GetGroceryEvent extends GroceryItemEvent {
  final String titleID;

  GetGroceryEvent({
    required this.titleID
  });
}

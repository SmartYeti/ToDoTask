// ignore_for_file: prefer_const_constructors_in_immutables

part of 'grocery_bloc.dart';

@immutable
class GroceryItemState {
  final StateStatus stateStatus;
  final String? errorMessage;
  final List<GroceryItemModel> groceryList;
  final bool isEmpty;
  final bool isUpdated;
  final bool isDeleted;

  GroceryItemState({
    required this.groceryList,
    this.errorMessage,
    required this.stateStatus,
    required this.isEmpty,
    required this.isUpdated,
    required this.isDeleted,
  });

  factory GroceryItemState.initial() => GroceryItemState(
        groceryList: const [],
        stateStatus: StateStatus.initial,
        isEmpty: false,
        isUpdated: false,
        isDeleted: false,
      );

  GroceryItemState copyWith({
    List<GroceryItemModel>? groceryList,
    StateStatus? stateStatus,
    String? errorMessage,
    bool? isEmpty,
    bool? isUpdated,
    bool? isDeleted,
  }) {
    return GroceryItemState(
      groceryList: groceryList ?? this.groceryList,
      stateStatus: stateStatus ?? this.stateStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isEmpty: isEmpty ?? this.isEmpty,
      isUpdated: isUpdated ?? this.isUpdated,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

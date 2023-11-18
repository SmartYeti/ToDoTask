// ignore_for_file: prefer_const_constructors_in_immutables

part of 'title_grocery_bloc.dart';

@immutable
class TitleGroceryState {
  final StateStatus stateStatus;
  final String? errorMessage;
  final List<GroceryTitleModel> titleGroceryList;
  final bool isEmpty;
  final bool isUpdated;
  final bool isDeleted;

  TitleGroceryState({
    required this.stateStatus,
    this.errorMessage,
    required this.titleGroceryList,
    required this.isEmpty,
    required this.isUpdated,
    required this.isDeleted,
  });

  factory TitleGroceryState.initial() => TitleGroceryState(
        stateStatus: StateStatus.initial,
        titleGroceryList: const [],
        isEmpty: false,
        isUpdated: false,
        isDeleted: false,
      );

  TitleGroceryState copyWith({
    StateStatus? stateStatus,
    String? errorMessage,
    List<GroceryTitleModel>? titleGroceryList,
    bool? isEmpty,
    bool? isUpdated,
    bool? isDeleted,
  }) {
    return TitleGroceryState(
        stateStatus: stateStatus ?? this.stateStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        titleGroceryList: titleGroceryList ?? this.titleGroceryList,
        isEmpty: isEmpty ?? this.isEmpty,
        isUpdated: isUpdated ?? this.isUpdated,
        isDeleted: isDeleted ?? this.isDeleted,
        );
  }
}

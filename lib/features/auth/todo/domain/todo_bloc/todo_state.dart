// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables

part of 'todo_bloc.dart';

@immutable
class TodoState {
  final List<TodoModel> todoList;
  final StateStatus stateStatus;
  final String? errorMessage;
  final bool isUpdated;
  final bool isEmpty;
  final bool isDeleted;

  TodoState({
    required this.todoList,
    required this.stateStatus,
    this.errorMessage,
    required this.isUpdated,
    required this.isEmpty,
    required this.isDeleted,
  });

  factory TodoState.initial() => TodoState(
      stateStatus: StateStatus.initial,
      todoList: const [],
      isUpdated: false,
      isEmpty: false,
      isDeleted: false,
      );

  TodoState copyWith({
    List<TodoModel>? todoList,
    StateStatus? stateStatus,
    String? errorMessage,
    bool? isUpdated,
    bool? isEmpty,
    bool? isDeleted,
  }) {
    return TodoState(
        todoList: todoList ?? this.todoList,
        stateStatus: stateStatus ?? this.stateStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        isUpdated: isUpdated ?? this.isUpdated,
        isEmpty: isEmpty ?? this.isEmpty,
        isDeleted:  isDeleted ?? this.isDeleted,
        );
  }
}

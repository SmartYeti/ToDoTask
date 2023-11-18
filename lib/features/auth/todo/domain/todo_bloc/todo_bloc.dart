import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_list/core/enum/state_status.enum.dart';
import 'package:todo_list/features/auth/todo/data/repository/todo_repository.dart';
import 'package:todo_list/features/auth/todo/domain/models/add_todo.model.dart';
import 'package:todo_list/features/auth/todo/domain/models/check_model.dart';
import 'package:todo_list/features/auth/todo/domain/models/create_todo.model.dart';
import 'package:todo_list/features/auth/todo/domain/models/delete.model.dart';
import 'package:todo_list/features/auth/todo/domain/models/update_todo.models.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc(TodoRepository todoRepository) : super(TodoState.initial()) {
    on<AddTodoEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, String> result =
          await todoRepository.addTaskRepo(event.addtodoModel);

      result.fold((error) {
        emit(
          state.copyWith(
            stateStatus: StateStatus.error,
            errorMessage: error,
          ),
        );

        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (todoId) {
        final currentTodoList = state.todoList;
        emit(
          state.copyWith(
            stateStatus: StateStatus.loaded,
            isEmpty: false,
            todoList: [
              ...currentTodoList,
              TodoModel(
                id: todoId,
                title: event.addtodoModel.title,
                description: event.addtodoModel.description,
              ),
            ],
          ),
        );
      });
    });
    on<GetTodoEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, List<TodoModel>> result =
          await todoRepository.getTaskRepo(event.userId);
      result.fold((error) {
        emit(
          state.copyWith(
            stateStatus: StateStatus.error,
            errorMessage: error,
          ),
        );
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (todoList) {
        if (todoList.isNotEmpty) {
          emit(
            state.copyWith(
                stateStatus: StateStatus.loaded,
                todoList: todoList,
                isUpdated: true,
                isEmpty: false),
          );
        } else {
          emit(
            state.copyWith(
              isEmpty: true,
              stateStatus: StateStatus.loaded,
            ),
          );
        }
        emit(state.copyWith(isUpdated: false));
      });
    });
    on<UpdateTodoEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, String> result =
          await todoRepository.updateTaskRepo(event.updateTodoModel);

      result.fold((error) {
        emit(
          state.copyWith(
            stateStatus: StateStatus.error,
            errorMessage: error,
          ),
        );
      }, (todoId) {
        final currentTodoList = state.todoList;
        final int index = currentTodoList.indexWhere(
          (element) => element.id == event.updateTodoModel.id,
        );
        final currentTodoModel = currentTodoList[index];
        currentTodoList.replaceRange(index, index + 1, [
          TodoModel(
              id: event.updateTodoModel.id,
              title: event.updateTodoModel.title,
              description: event.updateTodoModel.description,
              isChecked: currentTodoModel.isChecked),
        ]);
        emit(state.copyWith(
            stateStatus: StateStatus.loaded,
            todoList: [
              ...currentTodoList,
            ],
            isUpdated: true));
        emit(state.copyWith(isUpdated: false));
      });
    });
    on<CheckedEvent>((event, emit) async {
      final Either<String, Unit> result =
          await todoRepository.checkTaskRepo(event.checkTodoModel);

      result.fold((error) {
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (success) {
        final currentTodoList = state.todoList;
        final int index = currentTodoList.indexWhere(
          (element) => element.id == event.checkTodoModel.id,
        );
        final currentTodoModel = currentTodoList[index];
        currentTodoList.replaceRange(index, index + 1, [
          TodoModel(
            id: currentTodoModel.id,
            title: currentTodoModel.title,
            description: currentTodoModel.description,
            isChecked: event.checkTodoModel.isChecked,
          ),
        ]);
        emit(
          state.copyWith(
            todoList: [
              ...currentTodoList,
            ],
          ),
        );
      });
    });

    on<DeleteTodoEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, Unit> result =
          await todoRepository.deleteTaskRepo(event.deleteTaskModel);

      result.fold((error) {
        emit(
          state.copyWith(
            stateStatus: StateStatus.error,
            errorMessage: error,
          ),
        );

        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (success) {
        final currentDeleteList = state.todoList;
        currentDeleteList
            .removeWhere((TodoModel e) => e.id == event.deleteTaskModel.id);
        emit(state.copyWith(
          stateStatus: StateStatus.loaded,
          todoList: [
            ...currentDeleteList,
          ],
          isDeleted: true,
        ));
        if (currentDeleteList.isEmpty) {
          emit(state.copyWith(isEmpty: true));
        }
        emit(state.copyWith(isDeleted: false));
      });
    });
  }
}

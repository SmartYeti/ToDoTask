import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/core/enum/state_status.enum.dart';
import 'package:todo_list/features/auth/grocery/data/repository/title_grocery_reposiroty.dart';
import 'package:todo_list/features/auth/grocery/domain/grocery_title.models/add_title.model.dart';
import 'package:todo_list/features/auth/grocery/domain/grocery_title.models/delete_title.model.dart';
import 'package:todo_list/features/auth/grocery/domain/grocery_title.models/grocery_title.model.dart';
import 'package:todo_list/features/auth/grocery/domain/grocery_title.models/update_title.model.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

part 'title_grocery_event.dart';
part 'title_grocery_state.dart';

class TitleGroceryBloc extends Bloc<TitleGroceryEvent, TitleGroceryState> {
  TitleGroceryBloc(TitleGroceryRepository titleGroceryRepository)
      : super(TitleGroceryState.initial()) {
    on<AddTitleGroceryEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, String> result = await titleGroceryRepository
          .addTitleGroceryRepo(event.addTitleGroceryModel);

      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (addTitleGrocery) {
        final currentTitleGroceryList = state.titleGroceryList;
        emit(state.copyWith(
          stateStatus: StateStatus.loaded,
          titleGroceryList: [
            ...currentTitleGroceryList,
            GroceryTitleModel(
              id: addTitleGrocery,
              //give data to GroceryTitleModel => createdAt variable

              createdAt: DateTime.timestamp().toIso8601String(),
              title: event.addTitleGroceryModel.title,
            ),
          ],
          isEmpty: false,
        ));
      });
    });
    on<GetTitleGroceryEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, List<GroceryTitleModel>> result =
          await titleGroceryRepository.getTitleGroceryRepo(event.userId!);
      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (getTitleGroceryList) {
        if (getTitleGroceryList.isNotEmpty) {
          emit(state.copyWith(
            titleGroceryList: getTitleGroceryList,
            stateStatus: StateStatus.loaded,
            isUpdated: true,
            isEmpty: false,
          ));
        } else {
          emit(state.copyWith(isEmpty: true, stateStatus: StateStatus.loaded));
        }
        emit(state.copyWith(isUpdated: false));
      });
    });

    on<UpdateTitleGroceryEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, String> result = await titleGroceryRepository
          .updateTitleGroceryRepo(event.updateTitleGroceryModel);

      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (updateTitleGroceryList) {
        final currentTitleGroceryList = state.titleGroceryList;
        final int index = currentTitleGroceryList.indexWhere(
          (element) => element.id == event.updateTitleGroceryModel.id,
        );
        final currentTitleGroceryModel = currentTitleGroceryList[index];
        currentTitleGroceryList.replaceRange(
          index,
          index + 1,
          [
            GroceryTitleModel(
              id: currentTitleGroceryModel.id,
              createdAt: event.updateTitleGroceryModel.updatedAt,
              title: event.updateTitleGroceryModel.title,
            )
          ],
        );
        emit(state.copyWith(
            stateStatus: StateStatus.loaded,
            titleGroceryList: [
              ...currentTitleGroceryList,
            ],
            isUpdated: true));
        emit(state.copyWith(isUpdated: false));
      });
    });

    on<DeleteTitleGroceryEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, Unit> result = await titleGroceryRepository
          .deleteTitleGroceryRepo(event.deleteTitleGroceryModel);
      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (deleteTitleGrocerylist) {
        final currentTitleDeleteList = state.titleGroceryList;
        currentTitleDeleteList.removeWhere(
            (GroceryTitleModel e) => e.id == event.deleteTitleGroceryModel.id);
        emit(state.copyWith(
          stateStatus: StateStatus.loaded,
          titleGroceryList: [
            ...currentTitleDeleteList,
          ],
          isUpdated: true,
          isDeleted: true,
        ));
        if (currentTitleDeleteList.isEmpty) {
          emit(state.copyWith(isEmpty: true));
        }
        emit(state.copyWith(isUpdated: false, isDeleted: false));
      });
    });
  }
}

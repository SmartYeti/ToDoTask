import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/core/enum/state_status.enum.dart';
import 'package:todo_list/features/auth/grocery/data/repository/grocery_repository.dart';
import 'package:todo_list/features/auth/grocery/domain/models/add_grocery.model.dart';
import 'package:todo_list/features/auth/grocery/domain/models/delete_grocery.model.dart';
import 'package:todo_list/features/auth/grocery/domain/models/grocery.model.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:todo_list/features/auth/grocery/domain/models/update_grocery.model.dart';

part 'grocery_event.dart';
part 'grocery_state.dart';

class GroceryItemBloc extends Bloc<GroceryItemEvent, GroceryItemState> {
  GroceryItemBloc(GroceryRepository groceryRepository)
      : super(GroceryItemState.initial()) {
    on<AddGroceryEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, String> result =
          await groceryRepository.addGroceryRepo(event.addGroceryModel);

      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (addGrocery) {
        final currentGroceryList = state.groceryList;
        emit(
          state.copyWith(
              stateStatus: StateStatus.loaded,
              groceryList: [
                ...currentGroceryList,
                GroceryItemModel(
                  id: addGrocery,
                  productName: event.addGroceryModel.productName,
                  quantity: event.addGroceryModel.quantity,
                  price: event.addGroceryModel.price,
                ),
              ],
              isEmpty: false),
        );
      });
    });
    on<GetGroceryEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, List<GroceryItemModel>> result =
          await groceryRepository.getGroceryRepo(event.titleID);

      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (getGroceryList) {
        if (getGroceryList.isNotEmpty) {
          emit(state.copyWith(
            groceryList: getGroceryList,
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
    on<UpdateGroceryEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));

      final Either<String, String> result =
          await groceryRepository.updateGroceryRepo(event.updateGroceryModel);
      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (updateGroceryList) {
        final currentGrocerylist = state.groceryList;
        final int index = currentGrocerylist.indexWhere(
          (element) => element.id == event.updateGroceryModel.id,
        );
        currentGrocerylist.replaceRange(
          index,
          index + 1,
          [
            GroceryItemModel(
              id: event.updateGroceryModel.id,
              productName: event.updateGroceryModel.productName,
              quantity: event.updateGroceryModel.quantity,
              price: event.updateGroceryModel.price,
            ),
          ],
        );
        emit(
          state.copyWith(
            stateStatus: StateStatus.loaded,
            groceryList: [
              ...currentGrocerylist,
            ],
            isUpdated: true,
          ),
        );
        emit(state.copyWith(isUpdated: false));
      });
    });

    on<DeleteGroceryEvent>((event, emit) async {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final Either<String, Unit> result =
          await groceryRepository.deleteGroceryRepo(event.deleteGroceryModel);
      result.fold((error) {
        emit(state.copyWith(
            stateStatus: StateStatus.error, errorMessage: error));
        emit(state.copyWith(stateStatus: StateStatus.loaded));
      }, (deleteSuccess) {
        final currentDeleteList = state.groceryList;
        currentDeleteList.removeWhere(
            (GroceryItemModel e) => e.id == event.deleteGroceryModel.id);
        emit(
          state.copyWith(
              stateStatus: StateStatus.loaded,
              groceryList: [
                ...currentDeleteList,
              ],
              isDeleted: true),
        );
        if (currentDeleteList.isEmpty) {
          emit(state.copyWith(isEmpty: true));
        }
        emit(state.copyWith(isDeleted: false));
      });
    });
  }
}

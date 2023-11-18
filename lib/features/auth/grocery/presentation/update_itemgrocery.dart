import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/core/enum/state_status.enum.dart';
import 'package:todo_list/core/global_widgets/snackbar.widget.dart';
import 'package:todo_list/features/auth/grocery/domain/grocery_bloc/grocery_bloc.dart';
import 'package:todo_list/features/auth/grocery/domain/models/grocery.model.dart';
import 'package:todo_list/features/auth/grocery/domain/models/update_grocery.model.dart';

class UpdateGroceryItemPage extends StatefulWidget {
  const UpdateGroceryItemPage({super.key, required this.groceryItemModel});
  final GroceryItemModel groceryItemModel;

  @override
  State<UpdateGroceryItemPage> createState() => _UpdateGroceryItemPageState();
}

class _UpdateGroceryItemPageState extends State<UpdateGroceryItemPage> {
  late String _updateItemId;
  late TextEditingController _updateProductName;
  late TextEditingController _updateQuantity;
  late TextEditingController _updatePrice;
  late GroceryItemBloc _groceryItemBloc;

  @override
  void initState() {
    super.initState();
    _groceryItemBloc = BlocProvider.of<GroceryItemBloc>(context);
    widget.groceryItemModel;

    _updateItemId = widget.groceryItemModel.id;
    _updateProductName =
        TextEditingController(text: widget.groceryItemModel.productName);
    _updateQuantity =
        TextEditingController(text: widget.groceryItemModel.quantity);
    _updatePrice = TextEditingController(text: widget.groceryItemModel.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade200,
        leading: const SizedBox(
          height: 10,
          width: 10,
          child: Icon(Icons.update_sharp),
        ),
        title: const Text('Update Grocery Items'),
        titleTextStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.purple.shade400,
        ),
      ),
      body: BlocConsumer<GroceryItemBloc, GroceryItemState>(
        bloc: _groceryItemBloc,
        listener: _itemListener,
        builder: (context, state) {
          if (state.stateStatus == StateStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: SizedBox(
                    width: 600,
                    child: TextField(
                      controller: _updateProductName,
                      autofocus: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.horizontal()),
                          labelText: 'Product Name'),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: SizedBox(
                    width: 600,
                    child: TextField(
                      controller: _updateQuantity,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.horizontal()),
                          labelText: 'Qunatity'),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: SizedBox(
                    width: 600,
                    child: TextField(
                      controller: _updatePrice,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.horizontal()),
                          labelText: 'Price'),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 16),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple.shade200,
                                foregroundColor: Colors.purple.shade400),
                            onPressed: () {
                              _updateItem(context);
                            },
                            child: const Text('Update')),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 16),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple.shade200,
                                foregroundColor: Colors.purple.shade400),
                            onPressed: () {
                              _updateItem(context);
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel')),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _itemListener(BuildContext context, GroceryItemState state) {
    if (state.stateStatus == StateStatus.error) {
      SnackBarUtils.defualtSnackBar(state.errorMessage, context);
      return;
    }

    if (state.isUpdated) {
      Navigator.pop(context);
      SnackBarUtils.defualtSnackBar('Task successfully updated!', context);
      return;
    }
  }

  void _updateItem(BuildContext context) {
    _groceryItemBloc.add(
      UpdateGroceryEvent(
        updateGroceryModel: UpdateGroceryModel(
            id: _updateItemId,
            productName: _updateProductName.text,
            quantity: _updateQuantity.text,
            price: _updatePrice.text),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/core/enum/state_status.enum.dart';
import 'package:todo_list/core/global_widgets/snackbar.widget.dart';
import 'package:todo_list/features/auth/grocery/domain/grocery_bloc/grocery_bloc.dart';
import 'package:todo_list/features/auth/grocery/domain/grocery_title.models/grocery_title.model.dart';
import 'package:todo_list/features/auth/grocery/domain/models/add_grocery.model.dart';
import 'package:todo_list/features/auth/grocery/domain/models/delete_grocery.model.dart';
import 'package:todo_list/features/auth/grocery/domain/title_grocery_bloc/title_grocery_bloc.dart';
import 'package:todo_list/features/auth/grocery/presentation/update_itemgrocery.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.groceryTitleModel});
  final GroceryTitleModel groceryTitleModel;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late GroceryItemBloc _groceryBloc;

  late TitleGroceryBloc _titleGroceryBloc;
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  late String groceryId;
  late String title;

  @override
  void initState() {
    super.initState();
    //get ID from groceryTitleModel
    groceryId = widget.groceryTitleModel.id;

    _titleGroceryBloc = BlocProvider.of<TitleGroceryBloc>(context);
    _titleGroceryBloc.add(GetTitleGroceryEvent(userId: groceryId));

    //kani gi gamit para sa title kay di makita ang value sa id ingani-on kani pasabot sa ubos
    title = widget.groceryTitleModel.title;

    _groceryBloc = BlocProvider.of<GroceryItemBloc>(context);
    _groceryBloc.add(GetGroceryEvent(titleID: groceryId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TitleGroceryBloc, TitleGroceryState>(
      bloc: _titleGroceryBloc,
      listener: _titleGroceryListener,
      builder: (context, state) {
        //kani pasabot sa babaw
        // final title =
        //     state.titleGroceryList.where((e) => e.id == groceryId).first.title;
        if (state.stateStatus == StateStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.isUpdated) {
          Navigator.pop(context);
          SnackBarUtils.defualtSnackBar(
              'Grocery successfully updated!', context);
        }
        return Scaffold(
          appBar: AppBar(
            leading: const Icon(Icons.list_sharp),
            titleTextStyle: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade400),
            backgroundColor: Colors.purple.shade200,
            title: Text('$title List'),
          ),
          body: BlocConsumer<GroceryItemBloc, GroceryItemState>(
            listener: _groceryListener,
            builder: (context, groceryState) {
              if (groceryState.stateStatus == StateStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (groceryState.isEmpty) {
                return const SizedBox(
                  child: Center(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Text(
                        'No groceries to display',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                );
              }
              if(groceryState.isDeleted) {
                ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Items deleted'),
                  duration: Duration(seconds: 2),
                ),
              );
              }
              return ListView.builder(
                itemCount: groceryState.groceryList.length,
                itemBuilder: (context, index) {
                  final groceryList = groceryState.groceryList[index];
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) {
                      return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Delete Confirmation...'),
                            content: Text(
                                'Are you sure you want to delete ${groceryList.productName}?'),
                            actions: <Widget>[
                              ElevatedButton(
                                  onPressed: () {
                                    _deleteItem(context, groceryList.id);
                                  },
                                  child: const Text('Delete')),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'))
                            ],
                          );
                        },
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [Icon(Icons.delete), Text('Delete')],
                        ),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: _groceryBloc,
                              child: UpdateGroceryItemPage(
                                groceryItemModel: groceryList,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(
                            groceryList.productName,
                            style: const TextStyle(fontSize: 15),
                          ),
                          leading: Text(
                            groceryList.quantity,
                            style: const TextStyle(fontSize: 15),
                          ),
                          trailing: Text(
                            'Php${groceryList.price}',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                  ),
                  onPressed: () {
                    // _displayAddDialog(context);
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ),
              FloatingActionButton(
                backgroundColor: Colors.purple.shade200,
                onPressed: () {
                  _displayAddDialog(context);
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
        );
      },
    );
  }

  void _groceryListener(
      BuildContext context, GroceryItemState titleGroceryState) {
    if (titleGroceryState.stateStatus == StateStatus.error) {
      const Center(child: CircularProgressIndicator());
      SnackBarUtils.defualtSnackBar(titleGroceryState.errorMessage, context);
    }
  }

  void _titleGroceryListener(
      BuildContext context, TitleGroceryState titleGroceryState) {
    if (titleGroceryState.stateStatus == StateStatus.error) {
      const Center(child: CircularProgressIndicator());
      SnackBarUtils.defualtSnackBar(titleGroceryState.errorMessage, context);
    }
  }

  Future _displayAddDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Add groceries to your list'),
          content: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: _productNameController,
                  autofocus: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.horizontal()),
                      labelText: 'Product Name'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _quantityController,
                  autofocus: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.horizontal()),
                      labelText: 'Quantity'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _priceController,
                  autofocus: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.horizontal()),
                      labelText: 'Price'),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade200,
                foregroundColor: Colors.purple.shade400,
              ),
              child: const Text('ADD'),
              onPressed: () {
                _addGroceries(context);
                Navigator.of(context).pop();
                _productNameController.clear();
                _quantityController.clear();
                _priceController.clear();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade200,
                foregroundColor: Colors.purple.shade400,
              ),
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _addGroceries(BuildContext context) {
    _groceryBloc.add(AddGroceryEvent(
        addGroceryModel: AddGroceryModel(
      productName: _productNameController.text,
      quantity: _quantityController.text,
      price: _priceController.text,
      titleId: groceryId,
    )));
  }

  void _deleteItem(BuildContext context, String id) {
    _groceryBloc.add(
        DeleteGroceryEvent(deleteGroceryModel: DeleteGroceryModel(id: id)));
    Navigator.of(context).pop();
  }
}

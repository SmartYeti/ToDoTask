import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/core/enum/state_status.enum.dart';
import 'package:todo_list/core/global_widgets/snackbar.widget.dart';
import 'package:todo_list/features/auth/todo/domain/models/create_todo.model.dart';
import 'package:todo_list/features/auth/todo/domain/models/update_todo.models.dart';
import 'package:todo_list/features/auth/todo/domain/todo_bloc/todo_bloc.dart';

class MyFormPage extends StatefulWidget {
  const MyFormPage({super.key, required this.todoModel});
  final TodoModel todoModel;

  @override
  State<MyFormPage> createState() => _MyFormPageState();
}

class _MyFormPageState extends State<MyFormPage> {
  late TextEditingController _updatedId;
  late TextEditingController _updateTitleController;
  late TextEditingController _updateDescriptionController;
  late TodoBloc _todoBloc;

  @override
  void initState() {
    super.initState();
    _todoBloc = BlocProvider.of<TodoBloc>(context);
    widget.todoModel;
    _updateTitleController =
        TextEditingController(text: widget.todoModel.title);
    _updateDescriptionController =
        TextEditingController(text: widget.todoModel.description);
    _updatedId = TextEditingController(text: widget.todoModel.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade200,
        leading:
            const SizedBox(height: 10, width: 10, child: Icon(Icons.update)),
        title: const Text('Update Task'),
        titleTextStyle: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.purple.shade400),
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        bloc: _todoBloc,
        listener: _todoListener,
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
                      controller: _updateTitleController,
                      autofocus: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.horizontal()),
                          labelText: 'Title'),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: SizedBox(
                    width: 600,
                    child: TextField(
                      controller: _updateDescriptionController,
                      autofocus: true,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.horizontal()),
                          labelText: 'Description'),
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
                              foregroundColor: Colors.purple.shade400,
                            ),
                            onPressed: () {
                              _updateTask(context);
                            },
                            child: const Text('Update')),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 16),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple.shade200,
                              foregroundColor: Colors.purple.shade400,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel')),
                      )
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

  void _todoListener(BuildContext context, TodoState state) {
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

  void _updateTask(BuildContext context) {
    _todoBloc.add(
      UpdateTodoEvent(
        updateTodoModel: UpdateTodoModel(
            id: _updatedId.text,
            title: _updateTitleController.text,
            description: _updateDescriptionController.text),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_using_isar_db/core/common/text_field_config.dart';
import 'package:todo_list_using_isar_db/feature/todo_list/presentation/bloc/todo_bloc.dart';
import 'package:todo_list_using_isar_db/feature/todo_list/presentation/widgets/todo_card.dart';
import 'package:todo_list_using_isar_db/feature/todo_list/presentation/widgets/todo_dialog.dart';

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  Future<void> _showTodoDialog({
    String? id,
    String? initialTitle,
    String? initialDetails,
  }) async {
    await showDialog<Map<String, String>>(
      context: context,
      builder:
          (context) => DynamicDialog(
            dialogTitle: id == null ? 'Add New Todo' : 'Edit Todo Item',
            fields: [
              TextFieldConfig(
                id: 'todoTitle',
                labelText: 'Title',
                initialValue: initialTitle,
              ),
              TextFieldConfig(
                id: 'todoDetails',
                labelText: 'Details',
                initialValue: initialDetails,
                maxLines: 4,
              ),
            ],
            actionButtonText: id == null ? 'Add' : 'Update',
            onAction: (data) {
              final event =
                  id == null
                      ? AddTodoEvent(
                        title: data['todoTitle']!,
                        details: data['todoDetails']!,
                        isComplete: false,
                        updatedAt: DateTime.now(),
                      )
                      : UpdateTodoEvent(
                        id: id,
                        title: data['todoTitle'],
                        details: data['todoDetails'],
                        updatedAt: DateTime.now(),
                      );
              context.read<TodoBloc>().add(event);
              Navigator.pop(context);
            },
            onCancel: () => Navigator.pop(context),
          ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(String id) async {
    await showDialog(
      context: context,
      builder:
          (context) => DynamicDialog(
            message: 'Are you sure want to delete this item?',
            fields: const [],
            cancelButtonText: 'Cancel',
            actionButtonText: 'Delete',
            onAction: (_) {
              context.read<TodoBloc>().add(DeleteTodoEvent(id: id));
              Navigator.pop(context);
            },
            onCancel: () => Navigator.pop(context),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is TodoError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }
        },
        builder: (context, state) {
          if (state is TodoLoading || state is TodoInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TodoLoaded) {
            if (state.todos.isEmpty) {
              return const Center(child: Text('No todos yet. Add one!'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return TodoCard(
                  key: ValueKey(todo.id),
                  title: todo.title,
                  isComplete: todo.isComplete,
                  onCheckboxChanged: (val) {
                    context.read<TodoBloc>().add(
                      UpdateTodoEvent(
                        id: todo.id,
                        isComplete: val,
                        updatedAt: DateTime.now(),
                      ),
                    );
                  },
                  onEditPressed:
                      () => _showTodoDialog(
                        id: todo.id,
                        initialTitle: todo.title,
                        initialDetails: todo.details,
                      ),
                  onDeletePressed: () => _showDeleteConfirmationDialog(todo.id),
                );
              },
            );
          }

          return const SizedBox(); // fallback for unexpected states
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTodoDialog(),
        label: const Text('Add Todo'),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

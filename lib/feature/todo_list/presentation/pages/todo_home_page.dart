import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_using_isar_db/core/common/loading_indecator.dart';
import 'package:todo_list_using_isar_db/core/common/snack_bar.dart';
import 'package:todo_list_using_isar_db/feature/todo_list/presentation/bloc/todo_bloc.dart';
import 'package:todo_list_using_isar_db/feature/todo_list/presentation/pages/todo_details_page.dart';
import 'package:todo_list_using_isar_db/feature/todo_list/presentation/utils/show_todo_add_dialog.dart';
import 'package:todo_list_using_isar_db/feature/todo_list/presentation/utils/show_todo_delete_dialog.dart';
import 'package:todo_list_using_isar_db/feature/todo_list/presentation/utils/show_todo_edit_dialog.dart';
import 'package:todo_list_using_isar_db/feature/todo_list/presentation/widgets/todo_list_view.dart';

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),

      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is TodoError) {
            snackBar(context, 'Error: ${state.message}');
          }
        },
        builder: (context, state) {
          if (state is TodoLoading || state is TodoInitial) {
            return const LoadingIndicator();
          }

          if (state is TodoLoaded) {
            if (state.todos.isEmpty) {
              return const Center(child: Text('No todos yet. Add one!'));
            }

            return TodoListView(
              onTap: (todo) {
                Navigator.push(
                  context,
                  TodoDetailsPage.route(todo.title, todo.details),
                );
              },
              todos: state.todos,
              onEdit:
                  (todo) => showTodoEditDialog(
                    context: context,
                    id: todo.id,
                    initialTitle: todo.title,
                    initialDetails: todo.details,
                  ),
              onDelete: (id) => showTodoDeleteDialog(context: context, id: id),
              onToggleComplete: (id, val) {
                context.read<TodoBloc>().add(
                  UpdateTodoEvent(
                    id: id,
                    isComplete: val,
                    updatedAt: DateTime.now(),
                  ),
                );
              },
            );
          }

          return const SizedBox(); // fallback
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showTodoAddDialog(context: context),
        label: const Text('Add Todo'),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

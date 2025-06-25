import 'dart:async';
import 'package:todo_list_using_isar_db/feature/todo_list/data/datasource/todo_local_datasource.dart';
import 'package:todo_list_using_isar_db/feature/todo_list/data/models/todo_model.dart';

class TodoLocalDatasourceImpl implements TodoLocalDatasource {
  final List<TodoModel> _todos = [];
  final StreamController<List<TodoModel>> _streamController =
      StreamController<List<TodoModel>>.broadcast();

  void _emitChanges() {
    _streamController.add(List.unmodifiable(_todos));
  }

  @override
  Future<TodoModel> addTodo(TodoModel todo) async {
    _todos.add(todo);
    _emitChanges();
    return todo;
  }

  @override
  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
    _emitChanges();
  }

  @override
  Future<List<TodoModel>> getTodos() async {
    return List.unmodifiable(_todos);
  }

  @override
  Future<TodoModel> updateTodo(TodoModel updatedTodo) async {
    final index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index == -1) throw Exception("Todo not found");

    _todos[index] = updatedTodo;
    _emitChanges();
    return updatedTodo;
  }

  @override
  Stream<List<TodoModel>> watchTodos() {
    _emitChanges();
    return _streamController.stream;
  }
}

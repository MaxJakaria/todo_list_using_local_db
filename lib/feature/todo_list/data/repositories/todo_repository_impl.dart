import 'package:dartz/dartz.dart';
import 'package:todo_list_using_isar_db/core/error/failure.dart';
import 'package:todo_list_using_isar_db/feature/todo_list/data/datasource/todo_local_datasource.dart';
import 'package:todo_list_using_isar_db/feature/todo_list/data/models/todo_model.dart';
import 'package:todo_list_using_isar_db/feature/todo_list/domain/entities/todo.dart';
import 'package:todo_list_using_isar_db/feature/todo_list/domain/repositories/todo_repository.dart';
import 'package:uuid/uuid.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDatasource todoLocalDatasource;

  TodoRepositoryImpl({required this.todoLocalDatasource});

  @override
  Future<Either<Failure, Todo>> addTodo({
    required String title,
    required String details,
    required bool isComplete,
    required DateTime updatedAt,
  }) async {
    try {
      final newTodo = TodoModel(
        id: const Uuid().v4(),
        title: title,
        details: details,
        isComplete: isComplete,
        updatedAt: updatedAt,
      );
      final result = await todoLocalDatasource.addTodo(newTodo);
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo({required String id}) async {
    try {
      await todoLocalDatasource.deleteTodo(id);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    try {
      final todos = await todoLocalDatasource.getTodos();
      return Right(todos);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Todo>> updateTodo({
    required String id,
    String? title,
    String? details,
    bool? isComplete,
    DateTime? updatedAt,
  }) async {
    try {
      final existing = (await todoLocalDatasource.getTodos()).firstWhere(
        (todo) => todo.id == id,
      );

      final updated = (existing).copyWith(
        title: title,
        details: details,
        isComplete: isComplete,
        updatedAt: updatedAt ?? DateTime.now(),
      );

      final result = await todoLocalDatasource.updateTodo(updated);
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<Todo>>> watchTodos() async* {
    try {
      await for (final todos in todoLocalDatasource.watchTodos()) {
        yield Right(todos);
      }
    } catch (e) {
      yield Left(Failure(e.toString()));
    }
  }
}

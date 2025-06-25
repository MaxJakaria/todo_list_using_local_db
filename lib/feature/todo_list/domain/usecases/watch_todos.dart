import 'package:dartz/dartz.dart';
import 'package:todo_list_using_isar_db/core/error/failure.dart';
import 'package:todo_list_using_isar_db/core/usecase/usecase.dart';
import 'package:todo_list_using_isar_db/feature/todo_list/domain/entities/todo.dart';
import 'package:todo_list_using_isar_db/feature/todo_list/domain/repositories/todo_repository.dart';

class WatchTodos implements StreamUsecases<List<Todo>, NoParams> {
  final TodoRepository repository;

  WatchTodos({required this.repository});

  @override
  Stream<Either<Failure, List<Todo>>> call(NoParams params) {
    return repository.watchTodos();
  }
}

import 'package:dartz/dartz.dart';
import 'package:todo_list_using_isar_db/core/error/failure.dart';
import 'package:todo_list_using_isar_db/core/usecase/usecase.dart';
import 'package:todo_list_using_isar_db/feature/todo_list/domain/entities/todo.dart';
import 'package:todo_list_using_isar_db/feature/todo_list/domain/repositories/todo_repository.dart';

class GetTodos implements Usecase<List<Todo>, NoParams> {
  final TodoRepository repository;

  GetTodos({required this.repository});

  @override
  Future<Either<Failure, List<Todo>>> call(NoParams params) async {
    return await repository.getTodos();
  }
}

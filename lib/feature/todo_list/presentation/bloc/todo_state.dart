part of 'todo_bloc.dart';

@immutable
sealed class TodoState {
  const TodoState();
}

final class TodoInitial extends TodoState {}

final class TodoLoading extends TodoState {}

final class TodoLoaded extends TodoState {
  final List<Todo> todos;

  const TodoLoaded(this.todos);
}

final class TodoError extends TodoState {
  final String message;

  const TodoError(this.message);
}

import 'package:todo_list_using_isar_db/feature/todo_list/domain/entities/todo.dart';

class TodoModel extends Todo {
  TodoModel({
    required super.id,
    required super.title,
    required super.details,
    required super.isComplete,
    required super.updatedAt,
  });

  // Method to create a new TodoModel instance with updated values
  TodoModel copyWith({
    String? id,
    String? title,
    String? details,
    bool? isComplete,
    DateTime? updatedAt,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      details: details ?? this.details,
      isComplete: isComplete ?? this.isComplete,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

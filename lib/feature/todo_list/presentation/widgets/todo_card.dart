import 'package:flutter/material.dart';
import 'package:todo_list_using_isar_db/core/color/app_pallete.dart';

class TodoCard extends StatelessWidget {
  final String title;
  final bool isComplete;
  final Function(bool?) onCheckboxChanged;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

  const TodoCard({
    super.key,
    required this.title,
    required this.isComplete,
    required this.onCheckboxChanged,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Checkbox(value: isComplete, onChanged: onCheckboxChanged),
          Text(title),
          IconButton(
            onPressed: onEditPressed,
            icon: Icon(Icons.edit, color: edit),
          ),
          IconButton(
            onPressed: onDeletePressed,
            icon: Icon(Icons.delete, color: delete),
          ),
        ],
      ),
    );
  }
}

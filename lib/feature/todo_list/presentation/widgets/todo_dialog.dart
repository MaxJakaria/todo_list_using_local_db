import 'package:flutter/material.dart';
import 'package:todo_list_using_isar_db/core/common/dialog_button.dart';
import 'package:todo_list_using_isar_db/core/common/text_field_config.dart';

class DynamicDialog extends StatefulWidget {
  final String? dialogTitle;
  final String? message;
  final List<TextFieldConfig> fields;
  final String cancelButtonText;
  final String actionButtonText;
  final VoidCallback? onCancel;
  final Function(Map<String, String> result)? onAction;

  const DynamicDialog({
    super.key,
    this.dialogTitle,
    this.message,
    this.fields = const [],
    this.cancelButtonText = 'Cancel',
    required this.actionButtonText,
    this.onCancel,
    this.onAction,
  });

  @override
  State<DynamicDialog> createState() => _DynamicDialogState();
}

class _DynamicDialogState extends State<DynamicDialog> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (var config in widget.fields) {
      _controllers[config.id] = TextEditingController(
        text: config.initialValue ?? '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          (widget.dialogTitle != null)
              ? Center(child: Text(widget.dialogTitle!))
              : null,
      titlePadding:
          (widget.dialogTitle != null)
              ? EdgeInsets.only(top: 15, bottom: 5)
              : EdgeInsets.all(5),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.message != null) Text(widget.message!),
          ...widget.fields.map((config) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: TextField(
                controller: _controllers[config.id],
                decoration: InputDecoration(labelText: config.labelText),
                maxLines: config.maxLines,
                minLines: config.minLines,
              ),
            );
          }),
        ],
      ),
      actions: [
        DialogButton(
          text: widget.cancelButtonText,
          onPressed: () {
            if (widget.onCancel != null) {
              widget.onCancel!();
            } else {
              Navigator.pop(context);
            }
          },
          isPrimaryAction: false,
        ),
        DialogButton(
          text: widget.actionButtonText,
          onPressed: () {
            final result = <String, String>{};
            _controllers.forEach((id, controller) {
              result[id] = controller.text;
            });

            if (widget.onAction != null) {
              widget.onAction!(result);
            } else {
              Navigator.pop(context, result);
            }
          },
          isPrimaryAction: true,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }
}

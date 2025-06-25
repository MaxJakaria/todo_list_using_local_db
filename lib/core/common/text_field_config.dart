class TextFieldConfig {
  final String id;
  final String labelText;
  final String? initialValue;
  final int? maxLines;
  final int minLines;

  const TextFieldConfig({
    required this.id,
    required this.labelText,
    this.initialValue,
    this.maxLines = 1,
    this.minLines = 1,
  });
}

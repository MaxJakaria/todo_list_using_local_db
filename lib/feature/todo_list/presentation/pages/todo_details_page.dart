import 'package:flutter/material.dart';

class TodoDetailsPage extends StatelessWidget {
  static Route route(String title, String details) => MaterialPageRoute(
    builder: (context) => TodoDetailsPage(title: title, details: details),
  );
  final String title;
  final String details;

  const TodoDetailsPage({
    super.key,
    required this.title,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            Text('Details:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(details, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

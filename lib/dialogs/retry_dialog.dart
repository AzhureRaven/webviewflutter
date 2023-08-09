import 'package:flutter/material.dart';

class RetryDialog extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onRollback;
  final String title;
  final String content;
  const RetryDialog({Key? key, required this.onRetry,required this.onRollback, required this.title, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(onPressed: () {
          onRollback.call();
          Navigator.pop(context);
        }, child: const Text("Return prev Page")),
        TextButton(onPressed: () {
          onRetry.call();
          Navigator.pop(context);
        }, child: const Text("Try Again"))
      ],
    );
  }
}
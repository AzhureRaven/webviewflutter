import 'package:flutter/material.dart';
import 'package:webviewflutter/utilities/localization.dart';

class YesNoDialog extends StatelessWidget {
  final VoidCallback onSuccess;
  final String title;
  final String content;
  const YesNoDialog({Key? key, required this.onSuccess, required this.title, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(onPressed: () {
          Navigator.pop(context);
        }, child: Text(AppLocalization.of(context).translate("no"))),
        const SizedBox(width: 8.0),
        TextButton(onPressed: () {
          onSuccess.call();
          Navigator.pop(context);
        }, child: Text(AppLocalization.of(context).translate("yes")))
      ],
    );
  }
}
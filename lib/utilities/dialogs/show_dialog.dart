import 'package:flutter/material.dart';

Future<void> showInfoDialog(
  BuildContext context,
  String title,
  String text,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
        content: Text(
          text,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Okay"))
        ],
      );
    },
  );
}

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
}) {
  final options = optionsBuilder();
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
        content: Text(
          content,
          style: const TextStyle(color: Colors.black),
        ),
        actions: options.keys.map((optionTitle) {
          final T value = options[optionTitle];
          return TextButton(
            onPressed: () {
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(
              optionTitle,
              style: const TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
      );
    },
  );
}

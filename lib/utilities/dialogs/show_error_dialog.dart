import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          "An error occurred",
          style: TextStyle(color: Colors.black),
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
              child: const Text(
                "Okay",
                style: TextStyle(color: Colors.black),
              ))
        ],
      );
    },
  );
}

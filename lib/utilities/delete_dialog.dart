import 'package:flutter/cupertino.dart';
import 'package:mynotes/utilities/show_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Delete note",
    content: "Are you sure you want to delete this note forever?",
    optionsBuilder: () => {
      "Cancel": false,
      "Yes": true,
    },
  ).then((value) => value ?? false);
}

import 'package:flutter/cupertino.dart';
import 'package:mynotes/utilities/dialogs/show_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Delete item",
    content: "Are you sure you want to delete this item forever?",
    optionsBuilder: () => {
      "Cancel": false,
      "Yes": true,
    },
  ).then((value) => value ?? false);
}

Future<bool> showAcctDeleteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Delete Account",
    content:
        "Are you sure you want to delete your Account? This will delete the account and all associated data",
    optionsBuilder: () => {
      "Cancel": false,
      "Yes": true,
    },
  ).then((value) => value ?? false);
}

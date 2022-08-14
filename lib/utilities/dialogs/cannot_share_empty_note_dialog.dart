import 'package:flutter/cupertino.dart';
import 'package:mynotes/utilities/dialogs/show_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Sharing",
    content: "You cannot share an empty note",
    optionsBuilder: () => {"OK": null},
  );
}

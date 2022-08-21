import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/note/cloud_note.dart';
import '../../utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        return Dismissible(
          direction: DismissDirection.endToStart,
          key: Key(note.documentId),
          onDismissed: (direction) async {
            onDeleteNote(note);
          },
          confirmDismiss: (direction) async {
            return await showDeleteDialog(context);
          },
          background: Container(
            color: Colors.red.shade700,
            child: Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                  ),
                  Text(
                    " Delete",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
          ),
          child: ListTile(
            onTap: () {
              onTap(note);
            },
            title: Text(
              note.text,
              style: const TextStyle(color: Colors.white),
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}

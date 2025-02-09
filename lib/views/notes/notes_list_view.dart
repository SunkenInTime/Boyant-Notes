import 'package:flutter/material.dart';
import 'package:mynotes/main.dart';
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

        if (note.title.isNotEmpty && note.text.isNotEmpty) {
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
              child: const Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                note.title,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                note.text,
                style: const TextStyle(color: Colors.white70),
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        } else if (note.title.isNotEmpty && note.text.isEmpty) {
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
              child: const Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                note.title,
                style: const TextStyle(color: defTextColor),
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        } else {
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
              child: const Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }
      },
    );
  }
}

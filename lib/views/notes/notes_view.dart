import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/cloud/note/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../main.dart';
import '../../services/auth/auth_service.dart';
import 'notes_list_view.dart';
import '../main_ui.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: const Text("Your Notes"),
          backgroundColor: themeColor,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  createOrUpdateNoteRoute,
                );
              },
              icon: const Icon(Icons.add),
            ),
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(context);

                    if (shouldLogout) {
                      // Used to make sure I don't use build context accross async gaps
                      if (!mounted) return;

                      context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
                          );
                    }
                    break;
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text("Log out"),
                  )
                ];
              },
            )
          ],
        ),
        body: StreamBuilder(
            stream: _notesService.allNotes(ownerUserId: userId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:

                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final allNotes = snapshot.data as Iterable<CloudNote>;
                    return NotesListView(
                      notes: allNotes,
                      onDeleteNote: (note) async {
                        await _notesService.deleteNote(
                            documentId: note.documentId);
                      },
                      onTap: (note) {
                        Navigator.of(context).pushNamed(
                          createOrUpdateNoteRoute,
                          arguments: note,
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: SizedBox(
                        width: sizedBoxWidth,
                        height: sizedBoxHeight,
                        child: Center(child: loadingCircle),
                      ),
                    );
                  }

                default:
                  return Center(
                    child: SizedBox(
                      width: sizedBoxWidth,
                      height: sizedBoxHeight,
                      child: Center(child: loadingCircle),
                    ),
                  );
              }
            }));
  }
}

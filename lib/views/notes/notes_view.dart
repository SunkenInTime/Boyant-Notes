import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/note/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';

import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../main.dart';
import '../../services/auth/auth_service.dart';
import 'notes_list_view.dart';
import '../main_ui.dart';
import 'dart:developer';

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
        appBar: AppBar(
          title: const Text(
            "Your Notes",
          ),
          // backgroundColor: themeColor,
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
                      await AuthService.firebase().logOut();
                      if (!mounted) return;
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (_) => false,
                      );
                    }
                    break;
                  case MenuAction.settings:
                    Navigator.of(context).pushNamed(settingsRoute);
                    break;
                }
              },
              itemBuilder: (context) {
                return [
                  // const PopupMenuItem<MenuAction>(
                  //   value: MenuAction.settings,
                  //   child: Text(
                  //     "Settings",
                  //     style: TextStyle(color: Colors.black),
                  //   ),
                  // ),
                  const PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text(
                      "Log out",
                      style: TextStyle(color: Colors.black),
                    ),
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

                        // Navigator.of(context).pushNamed(
                        //   createOrUpdateNoteRoute,
                        //   arguments: note,
                        // );
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => CreateUpdateNoteView(),
                        //     settings: RouteSettings(arguments: note)
                        //   ),
                        // );
                        // Navigator.push(
                        //   context,
                        //   PageRouteBuilder(
                        //     transitionDuration: Duration(seconds: 2),
                        //     transitionsBuilder:
                        //         (context, animation, animationTime, child) {
                        //       return SizeTransition(
                        //         sizeFactor: CurvedAnimation(
                        //           curve: Curves.linear,
                        //           parent: controller,
                        //         ),
                        //         axis: Axis.vertical,
                        //         axisAlignment: 0,
                        //         child: child,
                        //       );
                        //     },
                        //     pageBuilder: (context, animation, animationTime) {
                        //       return CreateUpdateNoteView();
                        //     },
                        //     settings: RouteSettings(arguments: note),
                        //   ),
                        // );
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

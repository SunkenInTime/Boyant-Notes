// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/views/todo/todo_list_view.dart';

import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../main.dart';
import '../../services/auth/auth_service.dart';
import '../../services/cloud/todo/cloud_todo.dart';
import '../main_ui.dart';

class TodoView extends StatefulWidget {
  const TodoView({Key? key}) : super(key: key);

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  late final FirebaseCloudStorage _todoService;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _todoService = FirebaseCloudStorage();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo"),
        actions: [
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
                  Navigator.of(context).pushNamed(settingsRoute).then(
                    (_) {
                      Phoenix.rebirth(context);
                      log("Changed");
                    },
                  );
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.settings,
                  child: Text(
                    "Settings",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text(
                    "Log out",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ];
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _todoService.allTodo(ownerUserId: userId),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:

            case ConnectionState.active:
              if (snapshot.hasData) {
                final allTodo = snapshot.data as Iterable<CloudTodo>;
                return TodoListView(
                  todos: allTodo,
                  onDeleteTodo: (todo) async {
                    await _todoService.deleteTodo(documentId: todo.documentId);
                  },
                  onTap: (todo) {
                    showTextAreaSheet(context, todo);
                  },
                  onCheckTrue: (todo) async {
                    await _todoService.checkTodo(
                        documentId: todo.documentId, isChecked: true);
                  },
                  onCheckFalse: (todo) async {
                    await _todoService.checkTodo(
                        documentId: todo.documentId, isChecked: false);
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
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          showTextAreaSheet(context, null);
        }),
        // backgroundColor: themeColor,
        child: const Icon(Icons.add),
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  showTextAreaSheet(BuildContext context, CloudTodo? isExistingTodo) async {
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    bool isClicked = false;
    if (isExistingTodo != null) {
      _titleController.text = isExistingTodo.title;
      _descriptionController.text = isExistingTodo.description;
    } else {
      _titleController.text = "";
      _descriptionController.text = "";
    }
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context)
                    .viewInsets
                    .bottom), //keeps above keyboard
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                createSpace(1),
                TextField(
                  controller: _titleController,
                  keyboardType: TextInputType.multiline,
                  autofocus: true,
                  maxLines: null,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    border: InputBorder.none,
                    hintText: "Title",
                    hintStyle: TextStyle(color: Colors.black54),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                TextField(
                  controller: _descriptionController,
                  maxLines: null,
                  minLines: 1,
                  style: const TextStyle(height: 1, color: Colors.black),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 20),
                    hintText: "Description",
                    hintStyle: TextStyle(color: Colors.black54),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // IconButton(
                      //   onPressed: () {
                      //     showDatePicker(
                      //       context: context,
                      //       initialDate: DateTime.now(),
                      //       firstDate: DateTime(2021),
                      //       lastDate: DateTime(2101),
                      //     );
                      //   },
                      //   icon: Icon(
                      //     Icons.calendar_month_outlined,
                      //     color: Theme.of(context).primaryColor,
                      //   ),
                      // ),
                      TextButton(
                        onPressed: () async {
                          final title = _titleController.text;
                          final description = _descriptionController.text;
                          //Makes sure you can't input empty text
                          if (title != "" && isClicked == false) {
                            isClicked = true;

                            if (isExistingTodo != null) {
                              final CloudTodo todo = isExistingTodo;

                              Navigator.pop(context);
                              await _todoService.updateTodo(
                                  documentId: todo.documentId,
                                  title: title,
                                  description: description);
                            } else {
                              final CloudTodo todo = await _todoService
                                  .createNewTodo(ownerUserId: userId);

                              Navigator.pop(context);
                              await _todoService.updateTodo(
                                  documentId: todo.documentId,
                                  title: title,
                                  description: description);
                            }
                          }
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: const Text("Save"),
                      ),
                    ],
                  ),
                ),
                createSpace(20),
              ],
            ),
          );
        });
  }
}

// showModalBottomSheet(
//       isScrollControlled: true,
//       context: context,
//       builder: (BuildContext context) {
//         return Padding(
//           padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context)
//                   .viewInsets
//                   .bottom), //keeps above keyboard
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               createSpace(1),
//               const TextField(
//                 keyboardType: TextInputType.multiline,
//                 autofocus: true,
//                 maxLines: null,
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.only(left: 10),
//                   border: InputBorder.none,
//                   hintText: "Title",
//                 ),
//               ),
//               const TextField(
//                 style: TextStyle(height: 1),
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.only(left: 20),
//                   hintText: "Description",
//                 ),
//               ),
//             ],
//           ),
//         );
//       }
//       );
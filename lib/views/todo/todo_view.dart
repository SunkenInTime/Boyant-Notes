// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
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
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Todo"),
        backgroundColor: themeColor,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);

                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    if (!man) {} //used this to escape an error i have no idea how to fix :skull:
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
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
                    print("");
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
          showTextAreaSheet(context);
        }),
        backgroundColor: themeColor,
        child: const Icon(Icons.add),
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  showTextAreaSheet(BuildContext context) async {
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    bool isClicked = false;
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
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  maxLines: null,
                  minLines: 1,
                  style: const TextStyle(height: 1),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 20),
                    hintText: "Description",
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () async {
                            final title = _titleController.text;
                            final description = _descriptionController.text;
                            if (title != "" && isClicked == false) {
                              isClicked = true;
                              final CloudTodo todo = await _todoService
                                  .createNewTodo(ownerUserId: userId);

                              await _todoService.updateTodo(
                                  documentId: todo.documentId,
                                  title: title,
                                  description: description);
                              Navigator.pop(context);
                              _titleController.text = "";
                              _descriptionController.text = "";
                            }
                          },
                          child: const Text("Save")),
                    ],
                  ),
                )
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
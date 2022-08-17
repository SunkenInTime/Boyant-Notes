import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';

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

  @override
  void initState() {
    _todoService = FirebaseCloudStorage();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Todo"),
        backgroundColor: themeColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
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
      body: const Center(
        child: Text(
          "Todo list here",
          style: TextStyle(color: Colors.white),
        ),
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
    final CloudTodo todo =
        await _todoService.createNewTodo(ownerUserId: userId);

    void _titleControllerListener() async {
      final title = _titleController.text;
    }

    showModalBottomSheet(
        isScrollControlled: true,
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
                const TextField(
                  keyboardType: TextInputType.multiline,
                  autofocus: true,
                  maxLines: null,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    border: InputBorder.none,
                    hintText: "Title",
                  ),
                ),
                const TextField(
                  style: TextStyle(height: 1),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 20),
                    hintText: "Description",
                  ),
                ),
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
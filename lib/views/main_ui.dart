import 'package:flutter/material.dart';
import 'package:mynotes/main.dart';
import 'package:mynotes/views/notes/notes_view.dart';
import 'package:mynotes/views/todo/todo_view.dart';

class MainUIView extends StatefulWidget {
  const MainUIView({Key? key}) : super(key: key);

  @override
  State<MainUIView> createState() => _MainUIViewState();
}

const man = true;

class _MainUIViewState extends State<MainUIView> {
  int currentIndex = 0;
  final screens = const [NotesView(), TodoView()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //screen changing
      body: screens[currentIndex],
      // Bottom bar
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.white54,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        fixedColor: Colors.white,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notes_rounded,
              //color: Colors.white,
            ),
            label: "Notes",
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.checklist,
                //color: Colors.white,
              ),
              label: "Todo List",
              backgroundColor: themeColor),
        ],
        backgroundColor: themeColor,
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Sign out"),
        content: const Text("Are you sure you want to sign out"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("Log out"),
          )
        ],
      );
    },
  ).then((value) => value ?? false);
}

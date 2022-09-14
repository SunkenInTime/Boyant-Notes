import 'package:flutter/material.dart';
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
      body: screens[currentIndex],
      //screen changing
      // body: IndexedStack(
      //   index: currentIndex,
      //   children: screens,
      // ),
      // Bottom bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notes_rounded,
            ),
            label: "Notes",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.checklist,
            ),
            label: "Todo List",
          ),
        ],
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          "Sign out",
          style: TextStyle(color: Colors.black),
        ),
        content: const Text(
          "Are you sure you want to sign out",
          style: TextStyle(color: Colors.black),
        ),
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

import 'package:flutter/material.dart';
import 'package:mynotes/main.dart';
import 'package:mynotes/utilities/dialogs/delete_dialog.dart';
import 'package:mynotes/utilities/logic.dart';

import '../../services/cloud/todo/cloud_todo.dart';

typedef TodoCallback = void Function(CloudTodo todo);

class TodoListView extends StatelessWidget {
  final Iterable<CloudTodo> todos;
  final TodoCallback onDeleteTodo;
  final TodoCallback onTap;
  final TodoCallback onCheckTrue;
  final TodoCallback onCheckFalse;

  const TodoListView(
      {Key? key,
      required this.todos,
      required this.onDeleteTodo,
      required this.onTap,
      required this.onCheckTrue,
      required this.onCheckFalse})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos.elementAt(index);
        TextDecoration textDecoration;
        Color textColor;
        if (todo.isChecked) {
          textDecoration = TextDecoration.lineThrough;
          textColor = Colors.white54;
        } else {
          textDecoration = TextDecoration.none;
          textColor = defTextColor;
        }

        if (todo.description != "") {
          if (todo.dueDate != null) {
            return Dismissible(
              direction: DismissDirection.endToStart,
              key: Key(todo.documentId),
              onDismissed: (direction) async {
                onDeleteTodo(todo);
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
                  onTap(todo);
                },
                title: Text(
                  todo.title,
                  style:
                      TextStyle(color: textColor, decoration: textDecoration),
                ),
                subtitle: Text(
                  todo.description,
                  style: const TextStyle(color: Colors.white70),
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: Checkbox(
                  value: todo.isChecked,
                  onChanged: (value) {
                    if (value == true) {
                      onCheckTrue(todo);
                    } else {
                      onCheckFalse(todo);
                    }
                  },
                  activeColor: Theme.of(context).primaryColor,
                ),
                trailing: calculateDate(todo.dueDate!.toDate()),
              ),
            );
          } else {
            return Dismissible(
              direction: DismissDirection.endToStart,
              key: Key(todo.documentId),
              onDismissed: (direction) async {
                onDeleteTodo(todo);
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
                  onTap(todo);
                },
                title: Text(
                  todo.title,
                  style:
                      TextStyle(color: textColor, decoration: textDecoration),
                ),
                subtitle: Text(
                  todo.description,
                  style: const TextStyle(color: Colors.white70),
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: Checkbox(
                  value: todo.isChecked,
                  onChanged: (value) {
                    if (value == true) {
                      onCheckTrue(todo);
                    } else {
                      onCheckFalse(todo);
                    }
                  },
                  activeColor: Theme.of(context).primaryColor,
                ),
                // trailing: Text(todo.dueDate.toDate()),
              ),
            );
          }
        } else {
          if (todo.dueDate != null) {
            return Dismissible(
              direction: DismissDirection.endToStart,
              key: Key(todo.documentId),
              onDismissed: (direction) async {
                onDeleteTodo(todo);
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
                  onTap(todo);
                },
                title: Text(
                  todo.title,
                  style:
                      TextStyle(color: textColor, decoration: textDecoration),
                ),
                leading: Checkbox(
                  value: todo.isChecked,
                  onChanged: (value) {
                    if (value == true) {
                      onCheckTrue(todo);
                    } else {
                      onCheckFalse(todo);
                    }
                  },
                  activeColor: Theme.of(context).primaryColor,
                ),
                trailing: calculateDate(todo.dueDate!.toDate()),
              ),
            );
          } else {
            return Dismissible(
              direction: DismissDirection.endToStart,
              key: Key(todo.documentId),
              onDismissed: (direction) async {
                onDeleteTodo(todo);
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
                  onTap(todo);
                },
                title: Text(
                  todo.title,
                  style:
                      TextStyle(color: textColor, decoration: textDecoration),
                ),
                leading: Checkbox(
                  value: todo.isChecked,
                  onChanged: (value) {
                    if (value == true) {
                      onCheckTrue(todo);
                    } else {
                      onCheckFalse(todo);
                    }
                  },
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
            );
          }
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/delete_dialog.dart';

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
        return ListTile(
          onTap: () {
            onTap(todo);
          },
          title: Text(
            todo.title,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            todo.description,
            style: const TextStyle(color: Colors.white70),
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteTodo(todo);
              }
            },
            icon: const Icon(
              Icons.delete,
              color: Color.fromARGB(255, 102, 102, 102),
            ),
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
          ),
        );
      },
    );
  }
}

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
    List<CloudTodo> completedTasks = [];
    List activeTasks = [];

    for (final element in todos) {
      if (element.isChecked == true) {
        completedTasks.add(element);
      } else if (element.isChecked == false) {
        activeTasks.add(element);
      }
    }

    // completedTasks.sort((a, b) {
    //   log("I exist");
    //   if (a.dueDate == null) {
    //     return -1;
    //   }
    //   if (b.dueDate == null) {
    //     return 1;
    //   }
    //   int aNum = calculateDifferenceSort(a.dueDate!,b.dueDate!);
    //   int bNum = calculateDifferenceSort(b.dueDate!);
    //   log("a number is $aNum b number is $bNum");
    //   return aNum.compareTo(bNum);
    // });

    int amtCompleted = completedTasks.length;
    // Active tasks
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: activeTasks.length,
            itemBuilder: (context, index) {
              final todo = activeTasks[index];
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
                        onTap(todo);
                      },
                      title: Text(
                        todo.title,
                        style: TextStyle(
                            color: textColor, decoration: textDecoration),
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
                      trailing:
                          calculateDate(todo.dueDate!.toDate(), todo.isChecked),
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
                        onTap(todo);
                      },
                      title: Text(
                        todo.title,
                        style: TextStyle(
                            color: textColor, decoration: textDecoration),
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
                        onTap(todo);
                      },
                      title: Text(
                        todo.title,
                        style: TextStyle(
                            color: textColor, decoration: textDecoration),
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
                      trailing:
                          calculateDate(todo.dueDate!.toDate(), todo.isChecked),
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
                        onTap(todo);
                      },
                      title: Text(
                        todo.title,
                        style: TextStyle(
                            color: textColor, decoration: textDecoration),
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
          ),
        ),

        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Text(
        //     "Completed ($amtCompleted)",
        //     style: const TextStyle(
        //       fontWeight: FontWeight.bold,
        //       fontSize: 18,
        //     ),
        //     textAlign: TextAlign.left,
        //   ),
        // ),

        ExpansionTile(
          title: Text(
            "Completed ($amtCompleted)",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.left,
          ),
          children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              itemCount: completedTasks.length,
              itemBuilder: (context, index) {
                final todo = completedTasks[index];
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
                          onTap(todo);
                        },
                        title: Text(
                          todo.title,
                          style: TextStyle(
                              color: textColor, decoration: textDecoration),
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
                        trailing: calculateDate(
                            todo.dueDate!.toDate(), todo.isChecked),
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
                          onTap(todo);
                        },
                        title: Text(
                          todo.title,
                          style: TextStyle(
                              color: textColor, decoration: textDecoration),
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
                          onTap(todo);
                        },
                        title: Text(
                          todo.title,
                          style: TextStyle(
                              color: textColor, decoration: textDecoration),
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
                        trailing: calculateDate(
                            todo.dueDate!.toDate(), todo.isChecked),
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
                          onTap(todo);
                        },
                        title: Text(
                          todo.title,
                          style: TextStyle(
                              color: textColor, decoration: textDecoration),
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
            ),
          ],
        )
      ],
    );
  }
}

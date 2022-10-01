import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/cloud/todo/cloud_todo.dart';

Widget? calculateDate(DateTime comparedTime, bool isChecked) {
  int timeInDays = comparedTime.difference(DateTime.now()).inDays;

  if (comparedTime.day != DateTime.now().day && timeInDays == 0) {
    timeInDays = 1;
  }

  if (timeInDays <= 7 && timeInDays > 1) {
    //Within a week
    final formatedDate =
        DateFormat(DateFormat.ABBR_WEEKDAY).format(comparedTime);
    return Text(formatedDate);
  } else if (timeInDays > 7) {
    //too far into the future
    final formatedMonth =
        DateFormat(DateFormat.ABBR_MONTH).format(comparedTime);
    final formatedDay = comparedTime.day.toString();
    return Text("$formatedMonth $formatedDay");
  } else if (timeInDays == 0) {
    //If it is today
    return const Text("Today");
  } else if (timeInDays == 1) {
    return const Text("Tomorrow");
  }

  // Dates in the past
  if (timeInDays == -1) {
    if (isChecked == false) {
      return Text(
        "Yesterday",
        style: TextStyle(color: Colors.red.shade700),
      );
    } else {
      return const Text(
        "Yesterday",
      );
    }
    //Yesterday

  } else if (timeInDays < -1) {
    // Past yesterday in the past
    final formatedMonth =
        DateFormat(DateFormat.ABBR_MONTH).format(comparedTime);
    final formatedDay = comparedTime.day.toString();
    if (isChecked == false) {
      return Text(
        "$formatedMonth $formatedDay",
        style: TextStyle(color: Colors.red.shade700),
      );
    } else {
      return Text(
        "$formatedMonth $formatedDay",
      );
    }
  }
  log("Error in due date selection");
  return Text(
    "Error",
    style: TextStyle(color: Colors.red.shade700),
  );
}

int calculateDifferenceSort(CloudTodo aTodo, CloudTodo bTodo) {
  if (aTodo.dueDate != null && bTodo.dueDate == null) {
    return -1;
  } else if (aTodo.dueDate == null && bTodo.dueDate != null) {
    return 1;
  } else if (aTodo.dueDate != null && bTodo.dueDate != null) {
    final aTime = aTodo.dueDate!.toDate();
    final bTime = bTodo.dueDate!.toDate();
    final comparedTime = aTime.compareTo(bTime);
    if (comparedTime > 0) {
      return -1;
    } else {
      return 1;
    }
  } else {
    return -1;
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget? calculateDate(DateTime comparedTime) {
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
    //Yesterday
    return Text(
      "Yesterday",
      style: TextStyle(color: Colors.red.shade700),
    );
  } else if (timeInDays < -1) {
    // Past yesterday in the past
    final formatedMonth =
        DateFormat(DateFormat.ABBR_MONTH).format(comparedTime);
    final formatedDay = comparedTime.day.toString();
    return Text(
      "$formatedMonth $formatedDay",
      style: TextStyle(color: Colors.red.shade700),
    );
  }
  log("Error in due date selection");
  return Text(
    "Error",
    style: TextStyle(color: Colors.red.shade700),
  );
}

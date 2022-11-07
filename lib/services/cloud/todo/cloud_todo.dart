import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudTodo {
  final String documentId;
  final String userId;
  final String description;
  final String title;
  final bool isChecked;
  final Timestamp? dueDate;

  const CloudTodo({
    required this.dueDate,
    required this.documentId,
    required this.userId,
    required this.description,
    required this.title,
    required this.isChecked,
  });

  CloudTodo.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        userId = snapshot.data()[ownerUserIdFieldName],
        title = snapshot.data()[titleFieldName] as String,
        description = snapshot.data()[descriptionFieldName] as String,
        isChecked = snapshot.data()[isCheckedFieldName] as bool,
        dueDate = snapshot.data()[dueDateFieldName];
}

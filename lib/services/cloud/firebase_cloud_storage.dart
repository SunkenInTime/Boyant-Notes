import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/note/cloud_note.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:mynotes/services/cloud/note/cloud_storage_exceptions.dart';
import 'package:mynotes/services/cloud/todo/cloud_todo.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection("notes");
  final todoLists = FirebaseFirestore.instance.collection("todo");
  final userSettings = FirebaseFirestore.instance.collection("userSettings");

  //Notes
  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  // Todolist
  Future<void> deleteTodo({required String documentId}) async {
    try {
      await todoLists.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteTodoListException();
    }
  }

  // Note
  Future<void> updateNote({
    required String documentId,
    required String text,
    required String title,
  }) async {
    try {
      await notes.doc(documentId).update({
        textFieldName: text,
        titleFieldName: title,
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  // Todolist
  Future<void> updateTodo({
    required String documentId,
    required String title,
    required String description,
  }) async {
    try {
      await todoLists.doc(documentId).update({
        titleFieldName: title,
        descriptionFieldName: description,
      });
    } catch (e) {
      throw CouldNotUpdateTodoListException();
    }
  }

  Future<void> updateTodoTime(
      {required String documentId, required Timestamp? dueDate}) async {
    try {
      await todoLists.doc(documentId).update({dueDateFieldName: dueDate});
    } catch (e) {
      throw CouldNotUpdateDueException();
    }
  }

  // Todolist
  Future<void> checkTodo({
    required String documentId,
    required bool isChecked,
  }) async {
    try {
      await todoLists.doc(documentId).update({isCheckedFieldName: isChecked});
    } catch (e) {
      throw CouldNotUpdateCheckException();
    }
  }

  //Note
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    return notes
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));
  }

  //Todolist
  Stream<Iterable<CloudTodo>> allTodo({required String ownerUserId}) {
    return todoLists
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudTodo.fromSnapshot(doc)));
  }

  // Note
  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: "",
      titleFieldName: "",
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: "",
      title: "",
    );
  }

  // Todolist
  Future<CloudTodo> createNewTodo({required String ownerUserId}) async {
    final document = await todoLists.add({
      ownerUserIdFieldName: ownerUserId,
      titleFieldName: "",
      descriptionFieldName: "",
      isCheckedFieldName: false,
      dueDateFieldName: null,
    });
    final fecthedTodo = await document.get();
    return CloudTodo(
      documentId: fecthedTodo.id,
      userId: ownerUserId,
      description: "",
      title: "",
      isChecked: false,
      dueDate: null,
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}

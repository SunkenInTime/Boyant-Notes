import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/note/cloud_note.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:mynotes/services/cloud/note/cloud_storage_exceptions.dart';
import 'package:mynotes/services/cloud/todo/cloud_todo.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection("notes");
  final todoLists = FirebaseFirestore.instance.collection("todo");

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
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
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
    return notes.snapshots().map((event) => event.docs
        .map((doc) => CloudNote.fromSnapshot(doc))
        .where((note) => note.ownerUserId == ownerUserId));
  }

  //Todolist
  Stream<Iterable<CloudTodo>> allTodo({required String ownerUserId}) {
    return todoLists.snapshots().map((event) => event.docs
        .map((doc) => CloudTodo.fromSnapshot(doc))
        .where((todo) => todo.userId == ownerUserId));
  }

  //Note
  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserId,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllNoteException();
    }
  }

  // Todolist
  Future<Iterable<CloudTodo>> getTodos({required String ownerUserId}) async {
    try {
      return await todoLists
          .where(
            ownerUserId,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
              (value) => value.docs.map((doc) => CloudTodo.fromSnapshot(doc)));
    } catch (e) {
      throw CouldNotGetAllTodoListException();
    }
  }

  // Note
  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: "",
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: "",
    );
  }

  // Todolist
  Future<CloudTodo> createNewTodo({required String ownerUserId}) async {
    final document = await todoLists.add({
      ownerUserIdFieldName: ownerUserId,
      titleFieldName: "",
      descriptionFieldName: "",
      isCheckedFieldName: false,
    });
    final fecthedTodo = await document.get();
    return CloudTodo(
      documentId: fecthedTodo.id,
      userId: ownerUserId,
      description: "",
      title: "",
      isChecked: false,
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}

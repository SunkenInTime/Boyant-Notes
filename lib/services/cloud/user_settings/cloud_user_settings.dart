import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';

class UserSettings {
  final String theme;
  final String userId;
  final String documentId;

  UserSettings({
    required this.documentId,
    required this.theme,
    required this.userId,
  });

  UserSettings.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        userId = snapshot.data()[ownerUserIdFieldName],
        theme = snapshot.data()[themeFieldName];
}

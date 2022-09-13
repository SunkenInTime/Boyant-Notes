import 'package:hive/hive.dart';
import 'package:mynotes/services/hive/settings_service.dart';

class Boxes {
  static Box<UserSettings> getUserSettings() =>
      Hive.box<UserSettings>("user_settings");
}

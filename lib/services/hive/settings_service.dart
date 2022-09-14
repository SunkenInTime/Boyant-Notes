import 'package:hive/hive.dart';
part 'settings_service.g.dart';

@HiveType(typeId: 0)
class UserSettings extends HiveObject {
  @HiveField(0)
  final String theme;

  UserSettings(this.theme);
}

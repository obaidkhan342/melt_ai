import 'package:hive_flutter/hive_flutter.dart';

part 'settings.g.dart';

@HiveType(typeId: 2)
class Settings extends HiveObject {
  //storing bool value in db isdarktheme enable or disable..
  @HiveField(0)
  bool isDarkTheme = false;

  @HiveField(1)
  bool shouldSpeak = false;

  Settings({required this.isDarkTheme, required this.shouldSpeak});
}

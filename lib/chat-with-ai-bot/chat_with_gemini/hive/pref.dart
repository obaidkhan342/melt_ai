import 'package:hive_flutter/hive_flutter.dart';

part 'pref.g.dart';

// the following model using 

@HiveType(typeId: 2)
class Pref extends HiveObject{

  @HiveField(0)
  bool isDarkTheme = false;

  @HiveField(1)
  bool isShowOnboarding = false;

  Pref(
  {
    required this.isDarkTheme, required this.isShowOnboarding
  }
  );
}
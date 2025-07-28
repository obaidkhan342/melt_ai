// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

import '../hive/boxes.dart';
import '../hive/settings.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _shouldSpeak = false;

  bool get isDarkMode => _isDarkMode;
  bool get shouldSpeak => _shouldSpeak;

  void getSavedSettings(){
    final settingBox = Boxes.getSettings();
    if(settingBox.isNotEmpty){
      final settings = settingBox.getAt(0);
      _isDarkMode = settings!.isDarkTheme;
      _shouldSpeak = settings.shouldSpeak;
    }
  }

  void toggleDarkMode({
    required bool value,
    Settings? settings,
  }){
    if(settings != null){
      settings.isDarkTheme = value;
      settings.save();
    } else {
      final settingsBox = Boxes.getSettings();

      settingsBox.put(
          0, Settings(isDarkTheme: value, shouldSpeak: shouldSpeak)
		  );
    }
    _isDarkMode = value;
    notifyListeners();
  }

  // toggle the speak
  void toggleSpeak({
    required bool value,
    Settings? settings,
  }) {
    if (settings != null) {
      settings.shouldSpeak = value;
      settings.save();
    } else {
      // get the settings box
      final settingsBox = Boxes.getSettings();
      // save the settings
      settingsBox.put(0, Settings(isDarkTheme: isDarkMode, shouldSpeak: value));
    }
    _shouldSpeak = value;
    notifyListeners();
  }

}

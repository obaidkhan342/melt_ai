// ignore_for_file: prefer_final_fields, unused_local_variable

import 'package:flutter/material.dart';

import '../chat_with_gemini/hive/boxes.dart';
import '../chat_with_gemini/hive/pref.dart';

class PrefProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _isOnBoarding = true;

  bool get isDarkMode => _isDarkMode;
  bool get isOnBoarding => _isOnBoarding;

  void getSavedPref() {
    final prefBox = Boxes.getPref();
    if (prefBox.isNotEmpty) {
      final pref = prefBox.getAt(0);
      _isDarkMode = pref!.isDarkTheme;
      _isOnBoarding = pref.isShowOnboarding;
    }
  }

  void toggleDarkMode({required bool value, Pref? pref}) {
    if (pref != null) {
      pref.isDarkTheme = value;
      pref.save();
    } else {
      final prefBox = Boxes.getPref();
      prefBox.put(0, Pref(isDarkTheme: value, isShowOnboarding: isOnBoarding));
    }
    _isDarkMode = value;
    notifyListeners();
  }

  //set is onBoarding true / false
  void setOnBoarding({required bool value, Pref? pref}) {
    if (pref != null) {
      pref.isShowOnboarding = value;
      pref.save();
    } else {
      final prefBox = Boxes.getPref();
      prefBox.put(0, Pref(isDarkTheme: isDarkMode, isShowOnboarding: value));
    }
    _isOnBoarding = value;
    notifyListeners();
  }
}

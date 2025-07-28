// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

//light theme
ThemeData lightTheme = ThemeData(
  appBarTheme: AppBarTheme(
    // backgroundColor: Colors.blue
  ),
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.light,
  ),
  useMaterial3: true,
);

//dark Theme
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.deepPurple, 
  brightness: Brightness.dark),
  useMaterial3: true,
);

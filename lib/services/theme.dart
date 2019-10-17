import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  scaffoldBackgroundColor: Color.fromRGBO(31, 26, 36, 1),
  brightness: Brightness.dark,
  backgroundColor: const Color(0xFF212121),
  dialogBackgroundColor: Color.fromRGBO(51, 41, 64, 1),
  cardColor: Colors.white12,
  accentColor: Colors.white,
  accentIconTheme: IconThemeData(color: Colors.black),
  dividerColor: Colors.black12,
);

final lightTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  cardColor: Colors.orangeAccent,
  dialogBackgroundColor: Colors.black38,
  accentColor: Colors.black,
  accentIconTheme: IconThemeData(color: Colors.white),
  dividerColor: Colors.white54,
);
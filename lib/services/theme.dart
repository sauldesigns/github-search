import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  scaffoldBackgroundColor: Colors.black, // Color.fromRGBO(31, 26, 36, 1),
  brightness: Brightness.dark,
  backgroundColor: const Color(0xFF212121),
  dialogBackgroundColor: Color.fromRGBO(51, 41, 64, 1),
  cardColor: Colors.white12,
  accentColor: Colors.white,
  cursorColor: Colors.white,
  textTheme: TextTheme(
    title: TextStyle(
      color: Colors.white,
      fontSize: 20,
    ),
  ),
  accentIconTheme: IconThemeData(color: Colors.black),
  dividerColor: Colors.black12,
  toggleableActiveColor: Colors.white,
  splashColor: Colors.black,
);

final lightTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  textTheme: TextTheme(
    title: TextStyle(
      color: Colors.black,
      fontSize: 20,
    ),
  ),
  cursorColor: Colors.black,
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  cardColor: Colors.white,
  dialogBackgroundColor: Colors.white,
  accentColor: Colors.black,
  accentIconTheme: IconThemeData(color: Colors.white),
  dividerColor: Colors.white54,
  toggleableActiveColor: Colors.black,
  splashColor: Colors.white,
);

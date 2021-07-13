import 'package:flutter/material.dart';

final Color _primary = Colors.amber;
final Color _primary2 = Colors.amber[600];
final Color _primary3 = Colors.amber[800];

final Color _secondary = Colors.blue[400];
final Color _secondary2 = Colors.blue;

final Color _neutral = Colors.white;
final Color _neutral2 = Colors.grey[100];

final standardTheme = ThemeData(
    appBarTheme: AppBarTheme(backgroundColor: _primary2, centerTitle: true),
    canvasColor: _primary,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: _primary2,
      selectedItemColor: _neutral,
      unselectedItemColor: _neutral2,
    ),
    cardTheme: CardTheme(color: _primary2, shadowColor: _primary3, elevation: 5),
    iconTheme: IconThemeData(color: Colors.red),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _secondary2,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(_neutral),
      checkColor: MaterialStateProperty.all(_secondary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _primary2,
      focusColor: _secondary,
      border: OutlineInputBorder(),
    ),
    hintColor: _neutral,
    fontFamily: 'Roboto',
    textTheme: TextTheme(
        bodyText1: TextStyle(color: _neutral, fontSize: 10),
        bodyText2: TextStyle(color: _neutral, fontSize: 18),
        headline1: TextStyle(color: _neutral, fontSize: 25, fontWeight: FontWeight.bold),
        headline5: TextStyle(color: _neutral, fontSize: 22, fontWeight: FontWeight.bold)));

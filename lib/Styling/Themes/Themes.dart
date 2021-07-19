import 'package:flutter/material.dart';

final Color primary = Colors.blue;
final Color primary2 = Colors.blue[600];
final Color primary3 = Colors.blue[800];

final Color secondary = Colors.yellow[50];
final Color secondary2 = Colors.yellow[600];
final Color secondary3 = Colors.yellow[800];

final Color neutral = Colors.white;
final Color neutral2 = Colors.grey[100];

final Color neutralCompliment = Colors.black;

final standardTheme = ThemeData(
    appBarTheme: AppBarTheme(backgroundColor: neutral, centerTitle: true),
    canvasColor: neutral,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: neutral,
      selectedItemColor: primary2,
      unselectedItemColor: primary3,
    ),
    cardTheme: CardTheme(
        shape:
            RoundedRectangleBorder(side: BorderSide(width: 3, color: primary3), borderRadius: BorderRadius.circular(5)),
        color: neutral,
        shadowColor: primary3,
        elevation: 10),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary3,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(primary3),
      checkColor: MaterialStateProperty.all(neutral),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: neutral,
      focusColor: primary3,
      border: OutlineInputBorder(),
    ),
    buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 3, color: primary3), borderRadius: BorderRadius.circular(5))),
    textButtonTheme: TextButtonThemeData(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(primary3))),
    hintColor: primary3,
    fontFamily: 'Roboto',
    textTheme: TextTheme(
      button: TextStyle(color: neutral, fontSize: 18),
      bodyText1: TextStyle(color: primary3, fontSize: 11, fontWeight: FontWeight.bold),
      bodyText2: TextStyle(color: neutralCompliment, fontSize: 18),
      headline1: TextStyle(color: neutralCompliment, fontSize: 25, fontWeight: FontWeight.bold),
      headline2: TextStyle(color: neutralCompliment, fontSize: 20, fontWeight: FontWeight.bold),
      headline5: TextStyle(color: primary3, fontSize: 18),
    ));

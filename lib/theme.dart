import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  scaffoldBackgroundColor: const Color.fromARGB(207, 0, 0, 0),
  appBarTheme: AppBarTheme(
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    centerTitle: true,
    backgroundColor: const Color.fromARGB(207, 0, 0, 0),
    titleTextStyle: TextStyle(
      fontSize: 22,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
  colorScheme: ColorScheme.light(
    primary: Colors.white,
    onPrimary: Colors.black,
    secondary: Colors.pinkAccent,
    onSecondary: Colors.white,
    tertiary: Colors.amber,
    error: Colors.red,
    outline: const Color.fromARGB(55, 255, 255, 255),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      color: Color.fromARGB(200, 255, 255, 255),
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
  ),
  tabBarTheme: TabBarTheme(
    unselectedLabelColor: const Color.fromARGB(255, 0, 253, 38),
    labelColor: const Color.fromARGB(255, 253, 1, 1),
  ),
);

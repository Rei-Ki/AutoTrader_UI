import 'package:flutter/material.dart';

ThemeData lighMode = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: Colors.pink,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    centerTitle: true,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 22,
      fontWeight: FontWeight.w500,
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w200,
    ),
  ),
);

ThemeData darkMode = ThemeData(brightness: Brightness.dark);

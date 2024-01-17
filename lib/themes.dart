import 'package:flutter/material.dart';

ThemeData lighMode = ThemeData(
  primaryColor: Colors.pink,
  colorScheme: const ColorScheme.light(
    primary: Colors.pink,
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
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
    ),
    bodyLarge: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w700,
    ),
  ),
  iconTheme: IconThemeData(
    color: Colors.pink.shade700,
  ),
);

ThemeData darkMode = ThemeData(
  primaryColor: Colors.pink,
  colorScheme: const ColorScheme.dark(
    primary: Colors.pink,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black12,
    centerTitle: true,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.w500,
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    bodySmall: TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w300,
    ),
    bodyLarge: TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontWeight: FontWeight.w700,
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.pink,
  ),
);

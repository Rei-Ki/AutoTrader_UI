import 'package:flutter/material.dart';

final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    dividerColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black12,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 23,
          fontWeight: FontWeight.w500,
        )),
    listTileTheme: const ListTileThemeData(
      iconColor: Colors.black,
    ),
    textTheme: const TextTheme(
        bodyMedium: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w200,
        )));

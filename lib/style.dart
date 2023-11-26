import 'package:flutter/material.dart';

const mainTextStyle = TextStyle(
  fontSize: 16,
);

final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    dividerColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black12,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        )),
    listTileTheme: const ListTileThemeData(
      iconColor: Colors.black,
    ),
    textTheme: const TextTheme(
        bodyMedium: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w200,
        )));

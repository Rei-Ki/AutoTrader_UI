import 'package:flutter/material.dart';

ThemeData appTheme(BuildContext context, brightness) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: Colors.pink,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: brightness == Brightness.light ? Colors.black : Colors.white,
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
}

import 'package:flutter/material.dart';
import 'package:lotosui/routes.dart';
import 'package:lotosui/themes.dart';

void main() {
  runApp(const LotosApp());
}

class LotosApp extends StatelessWidget {
  const LotosApp({super.key});
  // Добавить темную тему и светлую
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      title: 'Lotos',
      themeMode: ThemeMode.system,
      theme: lightTheme,
      initialRoute: '/home',
      routes: routes,
    );
  }
}

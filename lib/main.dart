import 'package:lotosui/navigate_page.dart';
import 'package:lotosui/routes.dart';
import 'package:flutter/material.dart';
import 'package:lotosui/style.dart';

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
      title: 'Traider',
      themeMode: ThemeMode.system,
      theme: lightTheme,
      routes: routes,
      home: const NavigatePage(),
    );
  }
}

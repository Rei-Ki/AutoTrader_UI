import 'package:flutter/material.dart';
import 'package:lotosui/bloc/some_bloc.dart';
import 'package:lotosui/routes.dart';
import 'package:lotosui/themes.dart';

void main() {
  runApp(const LotosApp());
}

class LotosApp extends StatelessWidget {
  const LotosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      initialRoute: '/home',
      routes: routes,
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/main_bloc.dart';
import 'instrument_page/instrument_page.dart';
import 'package:lotosui/navigate_page.dart';
import 'package:flutter/material.dart';

/*
Сделать чтобы при нажатии на инструмент (актив) была страница его
и кнопка включить и он переходил в активные

todo Использовать Hive
*/

void main() {
  runApp(const LotosApp());
}

class LotosApp extends StatelessWidget {
  const LotosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        showPerformanceOverlay: false,
        title: 'Traider',
        theme: appTheme(context),
        routes: {
          '/home': (context) => const NavigatePage(),
          '/instrumentInfo': (context) => const InstrumentPage(),
        },
        home: const NavigatePage(),
      ),
    );
  }

  // Темы
  ThemeData appTheme(BuildContext context) {
    return ThemeData(
      // scaffoldBackgroundColor: background,
      // background: Colors.white
      // seedColor: Colors.pink

      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: Colors.pink,
      ),
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
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
}

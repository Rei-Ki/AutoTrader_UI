import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/bloc.dart';
import 'instrument_page/instrument_page.dart';
import 'package:lotosui/navigate_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const LotosApp());
}

/*
Сделать чтобы при нажатии на инструмент (актив) была страница его
и кнопка включить и он переходил в активные

todo Использовать Hive
*/

class LotosApp extends StatelessWidget {
  const LotosApp({super.key});
  // Добавить темную тему и светлую
  @override
  Widget build(BuildContext context) {
    // Переключение темы
    // final ThemeData themeData = ThemeData(
    //     useMaterial3: true,
    //     brightness: false ? Brightness.dark : Brightness.light);

    return BlocProvider(
      create: (context) => MainBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        showPerformanceOverlay: false,
        title: 'Traider',
        // theme: themeData,
        theme: appTheme(context),
        routes: {
          '/home': (context) => const NavigatePage(),
          '/instrumentInfo': (context) => const InstrumentPage(),
        },
        home: const NavigatePage(),
      ),
    );
  }

  ThemeData appTheme(BuildContext context) {
    return ThemeData(
      // primaryColor: Colors.purple,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.pink,
        surface: Colors.white,
      ),

      // colorSchemeSeed: ,
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
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
        ),
      ),
    );
  }
}

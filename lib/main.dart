import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'bloc/main_bloc.dart';
import 'instrument_page/instrument_page.dart';
import 'package:lotosui/navigate_page.dart';
import 'package:flutter/material.dart';
import 'repository.dart';

/*
Сделать чтобы при нажатии на инструмент (актив) была страница его
и кнопка включить и он переходил в активные

todo Использовать Hive
todo сделать обработку ошибки WS
todo Попробовать сменять все внутри скаффолда чтобы использовать лишь один блок
todo пофиксить переход на страницы (слетает активы)
todo использовать релейтив лейауты

todo починить название у страницы инструмента
todo сделать сохранение в ПЗУ (используя Hive) названий всех инструментов чтобы их не запрашивать зря (но иногда обновлять)
todo добавить страницу настроек
todo перенести объявление WebSockets в инициализацию блока главного
todo сделать смену тем
*/

void main() {
  GetIt.I.registerLazySingleton<WebSocketsRepository>(
    () => WebSocketsRepository("ws://localhost:8765"),
  );

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
    const brightness = Brightness.light;
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        brightness: brightness,
        seedColor: Colors.pink,
      ),
      appBarTheme: const AppBarTheme(
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
}

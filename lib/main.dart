import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/control_bloc.dart';
import 'bloc/main_bloc.dart';
import 'instrument_page/instrument_page.dart';
import 'package:lotosui/navigate_page.dart';
import 'package:flutter/material.dart';

import 'themes.dart';

/*
Сделать чтобы при нажатии на инструмент (актив) была страница его
и кнопка включить и он переходил в активные

todo Использовать Hive
todo использовать релейтив лейауты

todo сделать сохранение в ПЗУ (используя Hive) названий всех инструментов чтобы их не запрашивать зря (но иногда обновлять)
todo добавить страницу настроек
todo сделать смену тем
*/

void main() {
  runApp(const AutoTraderApp());
}

class AutoTraderApp extends StatelessWidget {
  const AutoTraderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MainBloc()),
        BlocProvider(create: (context) => ControlBloc()),
      ],
      child: buildControlBloc(),
    );
  }

  buildControlBloc() {
    return BlocBuilder<ControlBloc, ControlState>(builder: (context, state) {
      if (state is ChangeThemeState) {
        return buildMaterialApp(context, state.isDark);
      }

      return buildMaterialApp(context, false);
    });
  }

  MaterialApp buildMaterialApp(BuildContext context, themeMode) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      title: 'Traider',
      theme: themeMode
          ? appTheme(context, Brightness.light)
          : appTheme(context, Brightness.dark),
      routes: {
        '/home': (context) => const NavigatePage(),
        '/instrumentInfo': (context) => const InstrumentPage(),
      },
      home: const NavigatePage(),
    );
  }
}

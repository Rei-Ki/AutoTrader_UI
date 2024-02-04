import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'bloc/control_bloc.dart';
import 'hive/instruments_hive.dart';
import 'login_page/login_bloc.dart';
import 'bloc/main_bloc.dart';
import 'instrument_page/instrument_page.dart';
import 'package:lotosui/navigate_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'login_page/login_page.dart';
import 'themes.dart';

/*
todo Сделать чтобы при нажатии на инструмент была страница его и кнопка включить и он переходил в активные

todo Сделать при удалении инструмента в АКТИВНЫХ отключение его и убрать из активных
todo использовать релейтив лейауты

todo сделать не просто WS, а WSS (с TSL сертификатами)


todo подключить бд Firebase
todo Интерактивность: использовать снейк бар для уведомлений

todo Используйте BlocBuilder и различные состояния для заполнения пользовательского интерфейса на основе данных, считанных из Firebase Firestore

todo Интеграция с Firebase Firestore: 
Приложение должно подключаться к Firebase Firestore и включать по крайней мере одну коллекцию. 
Это проверит вашу способность работать с базами данных и облачными сервисами.

todo Добавить блок в instrument_page.dart
todo Добавить блок в login_page.dart
*/

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Hive.init("hive");
  Hive.registerAdapter(CachedInstrumentsDataAdapter());

  // Регистрация толкера (для логирования)
  GetIt.I.registerSingleton(TalkerFlutter.init());
  GetIt.I<Talker>().debug("Talker started...");

  Bloc.observer = TalkerBlocObserver(
    talker: GetIt.I<Talker>(),
    settings: const TalkerBlocLoggerSettings(
      printStateFullData: false,
      printEventFullData: false,
    ),
  );

  FlutterError.onError =
      (details) => GetIt.I<Talker>().handle(details.exception, details.stack);

  runTalkerZonedGuarded(
    GetIt.I<Talker>(),
    () => runApp(const AutoTraderApp()),
    (error, stack) => GetIt.I<Talker>().handle(error, stack),
  );
}

class AutoTraderApp extends StatefulWidget {
  const AutoTraderApp({super.key});

  @override
  State<AutoTraderApp> createState() => _AutoTraderAppState();
}

class _AutoTraderAppState extends State<AutoTraderApp> {
  late ControlBloc controlBloc;
  late LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();

    controlBloc = ControlBloc();
    GetIt.I.registerSingleton(controlBloc);
    loginBloc = LoginBloc();

    // controlBloc.wsIp = "localhost:33333";
    // controlBloc.wsIp = "192.168.0.5:33333";
    // FirebaseFirestore.instance.collection("settings").get().then(
    //   (querySnapshot) {
    //     print(querySnapshot);
    //     controlBloc.wsIp = "192.168.0.5:33333";
    //     // for (var doc in querySnapshot.docs) {
    //     //   print(doc);
    //     // }
    //   },
    // );

    loginBloc.loginResultStream.listen((bool result) {
      controlBloc.add(LoggingEvent(result));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MainBloc()),
        BlocProvider.value(value: controlBloc),
        BlocProvider.value(value: loginBloc),
      ],
      child: buildControlBloc(),
    );
  }

  buildControlBloc() {
    return BlocBuilder<ControlBloc, ControlState>(builder: (context, state) {
      bool isLogged = context.read<LoginBloc>().isLogged;

      if (state is ControlInitialState) {
        return buildMaterialApp(context, isLogged);
      }

      if (state is UpdateLoginState) {
        return buildMaterialApp(context, state.isLogged);
      }

      if (state is ChangeThemeState) {
        return buildMaterialApp(context, isLogged);
      }

      return buildMaterialApp(context, isLogged);
    });
  }

  MaterialApp buildMaterialApp(BuildContext context, isLogged) {
    var isDark = context.watch<ControlBloc>().isDark;
    LoginBloc loginBloc = context.read<LoginBloc>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      title: 'Traider',
      navigatorObservers: [
        TalkerRouteObserver(GetIt.I<Talker>()),
      ],
      theme: isDark ? lighMode : darkMode,
      routes: {
        '/home': (context) => const NavigatePage(),
        '/instrumentInfo': (context) => const InstrumentPage(),
        '/talkerScreen': (context) => TalkerScreen(talker: GetIt.I<Talker>()),
      },
      // todo сделать вход по логину
      home: isLogged ? const NavigatePage() : LoginPage(bloc: loginBloc),
    );
  }
}

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../bloc/data_classes.dart';
import '../repository.dart';

class InstrumentBloc extends Bloc<InstrumentEvent, InstrumentState> {
  late WSRepository repo = GetIt.I<WSRepository>();

  Instrument data;
  List<Candle> candles = [];

  InstrumentBloc({required this.data}) : super(InstrumentInitialState()) {
    on<UpdatePlotDataEvent>(onUpdatePlotData);
  }

  onUpdatePlotData(event, emit) async {
    try {
      //
      candles = await getPlotData();
      emit(UpdatePlotDataState(candles: candles));
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
    }
  }

  //! todo сделать чтобы данные получались из потока

  // other functions
  // todo сделать запросы к серверу по вебсоккетам для инструмента для графика
  Future<List<Candle>> getPlotData() async {
    // Map<String, dynamic> json = {
    //   "data": {"class_code": "SPBFUT"},
    //   "cmd": "get_all_instruments",
    // };

    Completer<List<Candle>> completer = Completer();
    List<Candle> candles = [];

    // repo.send(json); // отправка на сервер
    // Принимание и заполнение инструментов
    // repo.stream.listen((message) {
    //   var jsonRec = jsonDecode(message);
    //   for (var instrument in jsonRec["data"]) {
    //     instruments.add(
    //         Instrument(title: instrument, isActive: false, type: "Фьючерс"));
    //   }
    //   completer.complete(instruments);
    // });
    DateTime now = DateTime.now();

    for (var i = 0; i < 100; i++) {
      // Создание времени с шагом в 1 минуту
      DateTime candleTime = now.add(Duration(hours: i));

      // Форматирование времени в HH:MM
      // String formattedTime = DateFormat('dd.MM.yyyy HH:mm').format(candleTime);
      // String formattedTime = DateFormat('HH:mm').format(candleTime);

      candles.add(
        Candle(
          time: candleTime,
          open: math.Random().nextDouble() * 20 + 10,
          high: math.Random().nextDouble() * 20 + 10,
          low: math.Random().nextDouble() * 20 + 10,
          close: math.Random().nextDouble() * 20 + 10,
        ),
      );
    }
    completer.complete(candles);

    // Ждем завершения асинхронной операции
    return completer.future;
  }
}

abstract class InstrumentState {}

abstract class InstrumentEvent {}

class InstrumentInitialState extends InstrumentState {}

class InstrumentLoadingState extends InstrumentState {}

class InstrumentLoadedState extends InstrumentState {}

class InstrumentErrorState extends InstrumentState {}

// Запрос данных графика
class UpdatePlotDataState extends InstrumentState {
  List<Candle> candles;
  UpdatePlotDataState({required this.candles});
}

class UpdatePlotDataEvent extends InstrumentEvent {}

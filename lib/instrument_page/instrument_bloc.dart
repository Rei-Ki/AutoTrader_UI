import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'dart:math';
import '../bloc/data_classes.dart';
import '../repository.dart';

class InstrumentBloc extends Bloc<InstrumentEvent, InstrumentState> {
  late WSRepository repo = GetIt.I<WSRepository>();

  InstrumentBloc() : super(InstrumentInitialState()) {
    on<FetchPlotDataEvent>(onFetchPlotData);
  }

  onFetchPlotData(event, emit) async {
    try {
      List<Candle> data = await getPlotData();

      emit(FetchPlotDataState(data: data));
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
    }
  }

  // other functions
  // todo сделать запросы к серверу по вебсоккетам для инструмента для графика
  Future<List<Candle>> getPlotData() async {
    // Map<String, dynamic> json = {
    //   "data": {"class_code": "SPBFUT"},
    //   "cmd": "get_all_instruments",
    // };

    // todo сделать на сервере функцию
    // todo сделать запрос тут

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

    Random random = Random();

    for (int i = 0; i < 20; i++) {
      Candle candle = Candle(
        close: random.nextDouble() * 100,
        high: random.nextDouble() * 100,
        low: random.nextDouble() * 100,
        open: random.nextDouble() * 100,
      );

      candles.add(candle);
    }

    completer.complete(candles);

    // Ждем завершения асинхронной операции
    return completer.future;
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().error(error, stackTrace);
  }
}

abstract class InstrumentState {}

abstract class InstrumentEvent {}

class InstrumentInitialState extends InstrumentState {}

class InstrumentLoadingState extends InstrumentState {}

class InstrumentLoadedState extends InstrumentState {}

class InstrumentErrorState extends InstrumentState {}

// Запрос данных графика
class FetchPlotDataState extends InstrumentState {
  List<Candle> data;
  FetchPlotDataState({required this.data});
}

class FetchPlotDataEvent extends InstrumentEvent {
  String name;
  FetchPlotDataEvent({required this.name});
}

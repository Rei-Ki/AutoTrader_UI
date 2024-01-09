import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../bloc/data_classes.dart';
import '../repository.dart';

class InstrumentBloc extends Bloc<InstrumentEvent, InstrumentState> {
  late WSRepository repo = GetIt.I<WSRepository>();

  InstrumentBloc() : super(InstrumentInitialState()) {
    on<FetchPlotDataEvent>(onFetchPlotData);
  }

  onFetchPlotData(event, emit) async {
    try {
      //
    } catch (e, st) {
      //
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

    // todo оптимизировать чтобы каждый раз он не запрашивал а сохранил просто в памяти

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
  String name;
  FetchPlotDataState({required this.name});
}

class FetchPlotDataEvent extends InstrumentEvent {
  String name;
  FetchPlotDataEvent({required this.name});
}

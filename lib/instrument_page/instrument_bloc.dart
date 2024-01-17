import 'dart:convert';
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
    on<GetWSRepositoryUpdatePlotEvent>(getWSRepositoryUpdatePlot);

    // Подписываемся на события из репозитория и преобразуем их в состояние
    repo.subscribe((dynamic data) {
      Map<String, dynamic> decoded = jsonDecode(data);
      if (decoded["cmd"] == "get_chart_data") {
        add(GetWSRepositoryUpdatePlotEvent(json: decoded));
      }
    });
  }

  getWSRepositoryUpdatePlot(event, emit) async {
    try {
      List data =
          (event.json["data"] as List<dynamic>).cast<Map<String, dynamic>>();

      for (var item in data) {
        candles.add(Candle.fromJson(item));
      }

      emit(UpdatePlotDataState(candles: candles));
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
    }
  }

  onUpdatePlotData(event, emit) async {
    try {
      //! сделать в функцию эту чтобы она срабатывала при каждом смене таймфрейма и в событие передавался таймфрейм и иные данные
      //! потом учесть что есть возможность переключаться между таймфреймами а не только на одном сидеть
      //! пока сделать чтобы блокировалось переключение таймфреймов при запуске инструмента

      //TODO Сделать выбор интервала
      getRequestPlotData(data.title, "1", 50);

      emit(UpdatePlotDataState(candles: candles));
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
    }
  }

  // other functions
  getRequestPlotData(String secCode, String interval, count) {
    Map<String, dynamic> requestJson = {
      "data": {
        "class_code": "SPBFUT",
        "sec_code": secCode,
        "interval": interval,
        "count": count,
      },
      "cmd": "get_chart_data",
    };

    repo.send(requestJson); // отправка на сервер
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

class GetWSRepositoryUpdatePlotEvent extends InstrumentEvent {
  Map<String, dynamic>? json;
  GetWSRepositoryUpdatePlotEvent({required this.json});
}

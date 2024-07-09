import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../bloc/data_classes.dart';
import '../repository.dart';

class InstrumentBloc extends Bloc<InstrumentEvent, InstrumentState> {
  late WSRepository repo = GetIt.I<WSRepository>();
  late String currentInterval;

  Instrument data;
  List<Candle> candles = [];

  InstrumentBloc({required this.data}) : super(InstrumentInitialState()) {
    on<StartInstrumentEvent>(onStartInstrument);
    on<StopInstrumentEvent>(onStopInstrument);

    on<UpdatePlotDataEvent>(onUpdatePlotData);

    // события для репозитория
    on<GetWSRepositoryUpdatePlotEvent>(getWSRepositoryUpdatePlot);
    on<GetWSRepositoryUpdateActiveEvent>(getWSRepositoryUpdateActive);

    // Подписываемся на события из репозитория и преобразуем их в состояние
    repo.subscribe((dynamic data) {
      Map<String, dynamic> decoded = jsonDecode(data);
      if (decoded["cmd"] == "get_chart_data") {
        add(GetWSRepositoryUpdatePlotEvent(json: decoded));
      }

      if (decoded["cmd"] == "get_active_instrument") {
        add(GetWSRepositoryUpdateActiveEvent(json: decoded));
      }
    });
  }

  onStartInstrument(event, emit) {
    try {
      Map<String, dynamic> serverData = {
        "cmd": "start_instrument",
        "data": {
          "sec_code": event.secCode,
          "interval": event.interval,
          "strategy": event.strategy,
          "risk": event.risk,
          "plan_limit": event.planLimit,
        },
      };

      GetIt.I<Talker>()
          .info("Старт инструмента ${event.secCode} ${event.interval}");
      repo.send(serverData);
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
    }
  }

  onStopInstrument(event, emit) {
    try {
      Map<String, dynamic> serverData = {
        "cmd": "stop_instrument",
        "data": {"sec_code": event.secCode, "interval": event.interval},
      };

      GetIt.I<Talker>()
          .info("Остановка инструмента ${event.secCode} ${event.interval}");

      repo.send(serverData);
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
    }
  }

  getWSRepositoryUpdateActive(event, emit) {
    try {
      List<Map<String, dynamic>> serverData =
          List<Map<String, dynamic>>.from(event.json["data"]);

      // TODO сделать обновление данных для инструмента (вроде отображение что он стал активным и иное)
      GetIt.I<Talker>().info("getWSRepositoryUpdateActive: $serverData");
      // data.activeInterval = serverData[""]
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
    }
  }

  getWSRepositoryUpdatePlot(event, emit) async {
    try {
      List<Map<String, dynamic>> serverData =
          List<Map<String, dynamic>>.from(event.json["data"]);

      // Очистка перед принятием новых свечей
      candles = [];
      for (var item in serverData) {
        candles.add(Candle.fromJson(item));
      }

      emit(UpdatePlotDataState(candles: candles));
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
    }
  }

  onUpdatePlotData(event, emit) async {
    try {
      getRequestPlotData(data.title, event.timeframe, 100);

      emit(UpdatePlotDataState(candles: candles));
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
    }
  }

  // other functions
  getRequestPlotData(String secCode, String interval, count) {
    currentInterval = getInterval(interval);

    Map<String, dynamic> requestJson = {
      "data": {
        "class_code": "SPBFUT",
        "sec_code": secCode,
        "interval": getInterval(interval),
        "count": count,
      },
      "cmd": "get_chart_data",
    };

    repo.send(requestJson); // отправка на сервер
  }

  String getInterval(String timeFrameString) {
    int timeFrame = getDigitsFromString(timeFrameString);

    if (timeFrameString.contains("m")) {
      return timeFrame.toString();
    }
    if (timeFrameString.contains("h")) {
      return (timeFrame * 60).toString();
    }
    if (timeFrameString.contains("D")) {
      return (timeFrame * 60 * 24).toString();
    }
    if (timeFrameString.contains("W")) {
      return (timeFrame * 60 * 24 * 7).toString();
    }
    if (timeFrameString.contains("M")) {
      // NOTE 2 не совсем уверен в том что месяц именно 30
      return (timeFrame * 60 * 24 * 30).toString();
    }
    return timeFrameString; // возвращение того что поступил
  }

  int getDigitsFromString(String input) {
    RegExp regex = RegExp(r'\d+');
    Iterable<RegExpMatch> matches = regex.allMatches(input);
    return int.parse(matches.map((match) => match.group(0)!).join());
  }
}

abstract class InstrumentState {}

class InstrumentInitialState extends InstrumentState {}

class InstrumentLoadingState extends InstrumentState {}

class InstrumentLoadedState extends InstrumentState {}

class InstrumentErrorState extends InstrumentState {}

// Запрос данных графика
class UpdatePlotDataState extends InstrumentState {
  List<Candle> candles;
  UpdatePlotDataState({required this.candles});
}

abstract class InstrumentEvent {}

class UpdatePlotDataEvent extends InstrumentEvent {
  String timeframe;
  UpdatePlotDataEvent(this.timeframe);
}

class GetWSRepositoryUpdatePlotEvent extends InstrumentEvent {
  Map<String, dynamic>? json;
  GetWSRepositoryUpdatePlotEvent({required this.json});
}

class GetWSRepositoryUpdateActiveEvent extends InstrumentEvent {
  Map<String, dynamic>? json;
  GetWSRepositoryUpdateActiveEvent({required this.json});
}

class StartInstrumentEvent extends InstrumentEvent {
  String secCode, interval, strategy, risk, planLimit;
  StartInstrumentEvent({
    required this.secCode,
    required this.interval,
    required this.strategy,
    required this.risk,
    required this.planLimit,
  });
}

class StopInstrumentEvent extends InstrumentEvent {
  String secCode, interval;
  StopInstrumentEvent(this.secCode, this.interval);
}

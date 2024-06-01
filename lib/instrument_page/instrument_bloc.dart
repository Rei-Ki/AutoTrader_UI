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
    on<StartInstrument>(onStartInstrument);
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

  // TODO на стороне сервера делать словарь с запущенными уже инструментами и тд. при запросе всех инструментов
  /*
  при старте. запрос всех инструментов.
  Запрос всех инструментов,
  приходит словарь с инструментом как ключем и его внутри будет интервалы запущенные
  обработка его и отображение
  
  при старте 
  кидаем запрос о старте, 
  позже приходит что он запущен, и так же данные о его интервалах, 
  потом их заменять у исходного 

  при остановке
  запрос отправляем
  приходит ответ, что остановлен и активные интервалы для данного инструмента
  заменяем у исходного

  TODO подумать будет ли это работать для всех клиентов одинаково
  один отменил и у всех отменилось
  */
  onStartInstrument(event, emit) {
    try {
      Map<String, dynamic> data = {
        "cmd": "start_instrument",
        "data": {
          "sec_code": event.secCode,
          "interval": event.interval,
          "strategy": event.strategy,
          "risk": event.risk,
          "plan_limit": event.planLimit,
        },
      };

      GetIt.I<Talker>().info("Старт инструмента");
      repo.send(data);

      // TODO не добавлять в активные самому, а сделать чтобы сервер присылал что он успешно стал активным
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
    }
  }

  getWSRepositoryUpdatePlot(event, emit) async {
    try {
      if (event.json["status"] == "error" ||
          event.json.containsKey("error_message")) {
        print("${event.json["status"]}: ${event.json["error_message"]}");
        throw Exception(
            "${event.json["status"]}: ${event.json["error_message"]}");
      }

      List data =
          (event.json["data"] as List<dynamic>).cast<Map<String, dynamic>>();

      // Очистка перед принятием новых свечей
      candles = [];
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

class StartInstrument extends InstrumentEvent {
  String secCode, interval, strategy, risk, planLimit;
  StartInstrument({
    required this.secCode,
    required this.interval,
    required this.strategy,
    required this.risk,
    required this.planLimit,
  });
}

class EndInstrument extends InstrumentEvent {
  // TODO сделать стоп и на сервере и тут
}

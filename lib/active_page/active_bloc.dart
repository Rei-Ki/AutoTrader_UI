import 'package:talker_flutter/talker_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotosui/bloc/data_classes.dart';
import 'package:lotosui/repository.dart';
import 'package:get_it/get_it.dart';
import '../bloc/control_bloc.dart';
import '../hive/hive.dart';
import 'dart:convert';

class ActiveBloc extends Bloc<ActiveEvent, ActiveState> {
  Map<String, dynamic> requestJson = {
    "data": {"class_code": "SPBFUT"},
    "cmd": "get_all_instruments",
  };
  late WSRepository repo = GetIt.I<WSRepository>();

  Set<String> allTags = {};

  ActiveBloc() : super(ActiveInitialState()) {
    on<GetActiveEvent>(getActiveList);
    on<UpdateActiveEvent>(onUpdateActive);
    on<GetWSRepositoryActiveEvent>(getWSRepositoryActive);

    // Подписываемся на события из репозитория и преобразуем их в состояние
    repo.subscribe((dynamic data) {
      Map<String, dynamic> decoded = jsonDecode(data);
      if (decoded["cmd"] == "get_all_instruments") {
        add(GetWSRepositoryActiveEvent(json: decoded));
      }
    });
  }

  getWSRepositoryActive(event, emit) async {
    try {
      // Запрос с сервера, если кеш пуст или давно не обновлялось
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(event.json["data"]);

      List<Instrument> instruments = await fillInstrument(data);

      emit(ActiveLoadedState(instruments));

      await saveToCache(data, "instruments");
      GetIt.I<ControlBloc>().isInstrumentsDataUpdated = true;
      GetIt.I<Talker>()
          .info("Кеш не актуален. Инструменты загружены с сервера");
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
    }
  }

  getActiveList(event, emit) async {
    try {
      // Первичное обновление, поиск из кеша если он актуальный
      emit(ActiveLoadingState());

      List<Map<String, dynamic>> cachedData = await getFromCache("instruments");

      bool isDataUpdated = GetIt.I<ControlBloc>().isInstrumentsDataUpdated;
      print("isDataUpdated $isDataUpdated");
      if (cachedData.isNotEmpty && isDataUpdated) {
        GetIt.I<Talker>()
            .info("Обнаружен актуальный кеш, загружаем инструменты из кеша");

        List<Instrument> instruments = await fillInstrument(cachedData);

        for (var item in cachedData) {
          // создание списка всех тегов на основе имеющихся тегов
          Set<String> tmpTags = Set<String>.from(item["tags"]);
          allTags = allTags.union(tmpTags.toSet());
        }

        emit(ActiveLoadedState(instruments));
      } else {
        // Если кеш пуст, отправить запрос на сервер
        repo.send(requestJson);
        emit(ActiveLoadedState([]));
      }
    } catch (e, st) {
      emit(ActiveErrorState());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<List<Instrument>> fillInstrument(data) async {
    List<Instrument> instruments = [];

    for (var item in data) {
      Set<String> tagsSet = Set<String>.from(item["tags"]);
      List<String> intervals = List<String>.from(item["active_intervals"]);

      // TODO Подумать над type нужен ли он вообще
      instruments.add(
        Instrument(
          title: item["title"],
          tags: tagsSet,
          type: "Фьючерс",
          activeInterval: intervals,
        ),
      );
    }
    return instruments;
  }

  onUpdateActive(event, emit) {
    try {
      emit(UpdateActiveState(event.data));
    } catch (e, st) {
      emit(ActiveErrorState());
      GetIt.I<Talker>().handle(e, st);
    }
  }
}

// States
abstract class ActiveState {}

// Страница с инструментами
class ActiveInitialState extends ActiveState {}

class ActiveLoadingState extends ActiveState {}

class ActiveErrorState extends ActiveState {}

class ActiveLoadedState extends ActiveState {
  List<Instrument> instruments;
  ActiveLoadedState(this.instruments);
}

// Поиск
class UpdateActiveState extends ActiveState {
  List<Instrument> data;
  UpdateActiveState(this.data);
}

// Events
abstract class ActiveEvent {}

class GetActiveEvent extends ActiveEvent {}

class GetWSRepositoryActiveEvent extends ActiveEvent {
  Map<String, dynamic>? json;
  GetWSRepositoryActiveEvent({required this.json});
}

class UpdateActiveEvent extends ActiveEvent {
  List<Instrument> data;
  UpdateActiveEvent(this.data);
}

import 'package:talker_flutter/talker_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotosui/bloc/data_classes.dart';
import 'package:lotosui/repository.dart';
import 'package:get_it/get_it.dart';
import '../hive/hive.dart';
import 'dart:convert';

class ActiveBloc extends Bloc<ActiveEvent, ActiveState> {
  bool isDataUpdated =
      false; // чтобы хоть раз при заходе была актуальная информация
  Map<String, dynamic> requestJson = {
    "data": {"class_code": "SPBFUT"},
    "cmd": "get_all_instruments",
  };
  late WSRepository repo = GetIt.I<WSRepository>();

  List<String> allTags = ["Активные", "Фьючерсы"];

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
      List<Instrument> instruments = [];
      List<String> data = (event.json["data"] as List<dynamic>).cast<String>();

      for (var item in data) {
        instruments
            .add(Instrument(title: item.toString(), tags: [], type: "Фьючерс"));
      }

      emit(ActiveLoadedState(instruments));

      await saveToCache(data, "instruments");
      isDataUpdated = true;
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
    }
  }

  getActiveList(event, emit) async {
    try {
      emit(ActiveLoadingState());

      List<String> cachedData = await getFromCache("instruments");

      if (cachedData.isNotEmpty || isDataUpdated) {
        List<Instrument> instruments = [];

        for (var item in cachedData) {
          instruments.add(
              Instrument(title: item.toString(), tags: [], type: "Фьючерс"));
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

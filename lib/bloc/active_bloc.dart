import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotosui/bloc/data_classes.dart';
import 'package:lotosui/repository.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';

class ActiveBloc extends Bloc<ActiveEvent, ActiveState> {
  late WebSocketsRepository repo = GetIt.I<WebSocketsRepository>();

  ActiveBloc() : super(ActiveInitialState()) {
    on<GetActiveEvent>(getActiveList);
    on<ActiveSearchEvent>(searchActive);

    on<WebSocketsGetActiveEvent>(getActiveList);
  }

  getActiveList(event, emit) async {
    try {
      emit(ActiveLoadingState());
      List<Instrument> instuments = await getServerInstruments();
      emit(ActiveLoadedState(instuments));
    } catch (error) {
      emit(ActiveErrorState());
    }
  }

  searchActive(event, emit) async {
    try {
      String search = event.search;
      List<Instrument> allInstruments = event.instruments;
      List<Instrument> searchedList = [];

      // filtering of string
      allInstruments.forEach((instrument) {
        String title = instrument.title.toLowerCase();
        if (title.contains(search.toLowerCase())) {
          searchedList.add(instrument);
        }
      });

      emit(ActiveSearchingState(searchedList));
    } catch (error) {
      emit(ActiveErrorState());
    }
  }

  // other functions
  Future<List<Instrument>> getServerInstruments() async {
    Map<String, dynamic> json = {
      "data": {"class_code": "SPBFUT"},
      "cmd": "get_all_instruments",
    };

    Completer<List<Instrument>> completer = Completer();
    List<Instrument> instruments = [];

    // todo оптимизировать чтобы каждый раз он не запрашивал а сохранил просто в памяти

    repo.send(json); // отправка на сервер
    // Принимание и заполнение инструментов
    // repo.stream.listen((message) {
    //   var jsonRec = jsonDecode(message);
    //   for (var instrument in jsonRec["data"]) {
    //     instruments.add(
    //         Instrument(title: instrument, isActive: false, type: "Фьючерс"));
    //   }
    //   completer.complete(instruments);
    // });

    // закомментить при настоящей работе
    instruments.add(Instrument(
        title: "Пример инструмента", isActive: false, type: "Фьючерс"));
    completer.complete(instruments);

    // Ждем завершения асинхронной операции
    return completer.future;
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
class ActiveSearchingState extends ActiveState {
  List<Instrument> searched;
  ActiveSearchingState(this.searched);
}

// Соккеты
class WebSocketsActiveListState extends ActiveState {
  List<Instrument> data;
  WebSocketsActiveListState(this.data);
}

// Events
abstract class ActiveEvent {}

class GetActiveEvent extends ActiveEvent {}

class ActiveSearchEvent extends ActiveEvent {
  String search;
  List<Instrument> instruments;
  ActiveSearchEvent(this.search, this.instruments);
}

class WebSocketsGetActiveEvent extends ActiveEvent {
  Map<String, dynamic> data;
  WebSocketsGetActiveEvent(this.data);
}

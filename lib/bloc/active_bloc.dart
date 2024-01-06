import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotosui/bloc/data_classes.dart';
import 'package:lotosui/repository.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';

class ActiveBloc extends Bloc<ActiveEvent, ActiveState> {
  late WSRepository repo = GetIt.I<WSRepository>();

  ActiveBloc() : super(ActiveInitialState()) {
    on<GetActiveEvent>(getActiveList);
    on<UpdateActiveEvent>(onUpdateActive);

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

  onUpdateActive(event, emit) {
    try {
      emit(UpdateActiveState(event.data));
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

    // закомментить при настоящей работе
    instruments.add(Instrument(
      title: "Пример инструмента 1",
      type: "Фьючерс",
      tags: ['futures'],
    ));
    instruments.add(Instrument(
      title: "Пример инструмента 2",
      type: "Фьючерс",
      tags: ['active', 'futures'],
    ));

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
class UpdateActiveState extends ActiveState {
  List<Instrument> data;
  UpdateActiveState(this.data);
}

// Соккеты
class WebSocketsActiveListState extends ActiveState {
  List<Instrument> data;
  WebSocketsActiveListState(this.data);
}

// Events
abstract class ActiveEvent {}

class GetActiveEvent extends ActiveEvent {}

class UpdateActiveEvent extends ActiveEvent {
  List<Instrument> data;
  UpdateActiveEvent(this.data);
}

class WebSocketsGetActiveEvent extends ActiveEvent {
  Map<String, dynamic> data;
  WebSocketsGetActiveEvent(this.data);
}

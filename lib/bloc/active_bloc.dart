import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotosui/bloc/data_classes.dart';

class ActiveBloc extends Bloc<ActiveEvent, ActiveState> {
  ActiveBloc() : super(ActiveInitialState()) {
    on<GetActiveEvent>(getActiveList);
    on<ActiveSearchEvent>(searchActive);
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
  getServerInstruments() async {
    await Future.delayed(const Duration(microseconds: 1));
    // todo сделать подключение по вебсокетам к серверу
    // todo сделать async запрос к серверу за инструментами
    var inst1 = Instrument(isActive: true, title: "CRU3", type: "Фьючерс");
    var inst2 = Instrument(isActive: false, title: "SiZ3", type: "Фьючерс");
    var inst3 = Instrument(isActive: true, title: "SiU3", type: "Фьючерс");
    var inst4 = Instrument(isActive: false, title: "SRU3", type: "Фьючерс");

    List<Instrument> instruments = [inst1, inst2, inst3, inst4];
    return instruments;
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

// Events
abstract class ActiveEvent {}

class GetActiveEvent extends ActiveEvent {}

class ActiveSearchEvent extends ActiveEvent {
  String search;
  List<Instrument> instruments;
  ActiveSearchEvent(this.search, this.instruments);
}

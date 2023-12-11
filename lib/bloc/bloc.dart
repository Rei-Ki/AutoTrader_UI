import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'data_classes.dart';
import 'states.dart';
import 'events.dart';

/*
  Смена тем
  смена стилей

  todo делать так чтобы тут была смена темы и наверное вебсоккеты обрабатывать
  todo сделать смену темы, задника, смену названия AppBar navigate_page
*/

class MainBloc extends Bloc<Event, State> {
  MainBloc() : super(InitialState()) {
    // Pulse Events
    on<GetPulseEvent>(getPulse); //
    on<PulseSearchEvent>(pulseSearch); //

    // Analytics Events
    on<AnalyticsDataLoadEvent>(getSegmentsData); //

    // Main Events
    on<MainSetAppBarTitleEvent>(setAppBarTitle); //

    // Active Events
    on<GetActiveEvent>(getActive); //
    on<ActiveSearchEvent>(searchActive); //
  }

  getPulse(event, emit) async {
    try {
      emit(PulseLoadingState());
      List<Pulse> pulse = await getServerPulse();
      emit(PulseLoadedState(pulse));
    } catch (error) {
      emit(PulseErrorState());
    }
  }

  getActive(event, emit) async {
    try {
      emit(ActiveLoadingState());
      List<Instrument> instuments = await getServerInstruments();
      emit(ActiveLoadedState(instuments));
    } catch (error) {
      emit(ActiveErrorState());
    }
  }

  getSegmentsData(event, emit) async {
    try {
      emit(AnalyticsLoadingState());
      List<Segment> segments = await getServerSegmentsData();
      emit(AnalyticsLoadedState(segments));
    } catch (error) {
      emit(AnalyticsErrorState());
    }
  }

  setAppBarTitle(event, emit) async {
    try {
      emit(MainAppBarUpdatedState(event.title));
    } catch (error) {
      emit(MainErrorState());
    }
  }

  // Requests to the server
  pushServer() async {}

  getServerPulse() async {
    await Future.delayed(const Duration(microseconds: 1));

    // todo сделать async запрос к серверу за пульсом

    var p1 = Pulse(
      title: 'CRU3',
      operation: "покупка",
      date: DateFormat('dd.MM.yy\nkk:mm').format(DateTime.now()),
      price: 100,
      quantity: 2,
    );
    var p2 = Pulse(
      title: 'SiZ3',
      operation: "покупка",
      date: DateFormat('dd.MM.yy\nkk:mm').format(DateTime.now()),
      price: 200,
      quantity: 4,
    );
    var p3 = Pulse(
      title: 'SiZ3',
      operation: "продажа",
      date: DateFormat('dd.MM.yy\nkk:mm').format(DateTime.now()),
      price: 130,
      quantity: 1,
    );
    var p4 = Pulse(
      title: 'CRU3',
      operation: "продажа",
      date: DateFormat('dd.MM.yy\nkk:mm').format(DateTime.now()),
      price: 150,
      quantity: 1,
    );
    var p5 = Pulse(
      title: 'CRU3',
      operation: "продажа",
      date: DateFormat('dd.MM.yy\nkk:mm').format(DateTime.now()),
      price: 110,
      quantity: 1,
    );

    List<Pulse> pulses = [p1, p2, p3, p4, p5];
    return pulses;
  }

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

  getServerSegmentsData() async {
    await Future.delayed(const Duration(microseconds: 1));
    List<Segment> segments = [
      Segment(name: "AAPL", value: 1500),
      Segment(name: "GOOGL", value: 2000),
      Segment(name: "MSFT", value: 1200),
      Segment(name: "AMZN", value: 1800),
      Segment(name: "FB", value: 2500),
      Segment(name: "JPM", value: 1600),
      Segment(name: "XOM", value: 3000),
      Segment(name: "Свободные", value: 4200),
    ];

    return segments;
  }

  // Реализация поиска для страниц
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

  pulseSearch(event, emit) async {
    try {
      String search = event.search;
      List<Pulse> allPulses = event.pulses;
      List<Pulse> searchedList = [];

      // filtering of string
      allPulses.forEach((instrument) {
        String title = instrument.title.toLowerCase();
        if (title.contains(search.toLowerCase())) {
          searchedList.add(instrument);
        }
      });

      emit(PulseSearchingState(searchedList));
    } catch (error) {
      emit(PulseErrorState());
    }
  }
}

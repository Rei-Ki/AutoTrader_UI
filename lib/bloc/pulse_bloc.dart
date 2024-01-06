import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lotosui/bloc/data_classes.dart';

class PulseBloc extends Bloc<PulseEvent, PulseState> {
  PulseBloc() : super(PulseInitialState()) {
    on<GetPulseEvent>(getPulse);
    on<UpdatePulseEvent>(onUpdatePulse);
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

  onUpdatePulse(event, emit) async {
    try {
      emit(UpdatePulseState(event.data));
    } catch (error) {
      emit(PulseErrorState());
    }
  }

  // other functions
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
}

// States
abstract class PulseState {}

class PulseInitialState extends PulseState {}

class PulseLoadingState extends PulseState {}

class PulseLoadedState extends PulseState {
  List<Pulse> pulses;
  PulseLoadedState(this.pulses);
}

class PulseErrorState extends PulseState {}

// Events
abstract class PulseEvent {}

class GetPulseEvent extends PulseEvent {}

// Search
class UpdatePulseEvent extends PulseEvent {
  List<Pulse> data;
  UpdatePulseEvent(this.data);
}

class UpdatePulseState extends PulseState {
  List<Pulse> data;
  UpdatePulseState(this.data);
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainInitialState()) {
    on<MainSetAppBarTitleEvent>(setAppBarTitle);
  }

  setAppBarTitle(event, emit) async {
    try {
      emit(MainAppBarUpdatedState(event.title));
    } catch (e, st) {
      emit(MainErrorState());
      GetIt.I<Talker>().handle(e, st);
    }
  }

  // other functions
}

// States ------------------------------------
abstract class MainState {}

class MainInitialState extends MainState {}

class MainAppBarUpdatedState extends MainState {
  String title;
  MainAppBarUpdatedState(this.title);
}

class MainErrorState extends MainState {}

class MainChangeActive extends MainState {}

class MainChangePulse extends MainState {}

class MainChangeAnalytics extends MainState {}

// Events ------------------------------------
abstract class MainEvent {}

class MainSetAppBarTitleEvent extends MainEvent {
  String title;
  MainSetAppBarTitleEvent(this.title);
}

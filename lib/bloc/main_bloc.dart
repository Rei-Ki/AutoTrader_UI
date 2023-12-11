import 'package:flutter_bloc/flutter_bloc.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainInitialState()) {
    on<MainSetAppBarTitleEvent>(setAppBarTitle);
  }

  setAppBarTitle(event, emit) async {
    try {
      emit(MainAppBarUpdatedState(event.title));
    } catch (error) {
      emit(MainErrorState());
    }
  }

  // other functions
  get() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}

/*
  Смена тем
  смена стилей

  todo делать так чтобы тут была смена темы и наверное вебсоккеты обрабатывать
  todo сделать смену темы, задника, смену названия AppBar navigate_page
*/

// States ------------------------------------
abstract class MainState {}

class MainInitialState extends MainState {}

class MainAppBarUpdatedState extends MainState {
  String title;
  MainAppBarUpdatedState(this.title);
}

class MainErrorState extends MainState {}

// Events ------------------------------------
abstract class MainEvent {}

class MainSetAppBarTitleEvent extends MainEvent {
  String title;
  MainSetAppBarTitleEvent(this.title);
}

class MainSetThemeEvent extends MainEvent {}

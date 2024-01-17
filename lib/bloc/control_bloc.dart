import 'package:flutter_bloc/flutter_bloc.dart';

class ControlBloc extends Bloc<ControlEvent, ControlState> {
  // todo сохранить переменную в ПЗУ при изменении
  // todo сделать запрос к хранилищу данных чтобы спросить какая была тема
  bool isDark = true;
  bool isInstrumentsDataUpdated = false;

  ControlBloc() : super(ControlInitialState()) {
    on<ChangeThemeEvent>(onChangeThemeEvent);
    on<LoggingEvent>(onLoggingEvent);
  }

  onLoggingEvent(event, emit) async {
    emit(UpdateLoginState(event.isLogged));
  }

  onChangeThemeEvent(event, emit) async {
    isDark = !isDark;
    emit(ChangeThemeState(isDark));
  }

  // other functions
}

// States ------------------------------------
abstract class ControlState {}

class ControlInitialState extends ControlState {}

class ChangeThemeState extends ControlState {
  bool isDark;
  ChangeThemeState(this.isDark);
}

class UpdateLoginState extends ControlState {
  bool isLogged;
  UpdateLoginState(this.isLogged);
}

// Events ------------------------------------
abstract class ControlEvent {}

class ChangeThemeEvent extends ControlEvent {}

class LoggingEvent extends ControlEvent {
  bool isLogged;
  LoggingEvent(this.isLogged);
}

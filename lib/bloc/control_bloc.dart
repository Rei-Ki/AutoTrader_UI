import 'package:flutter_bloc/flutter_bloc.dart';

class ControlBloc extends Bloc<ControlEvent, ControlState> {
  // todo сохранить переменную в ПЗУ при изменении
  // todo сделать запрос к хранилищу данных чтобы спросить какая была тема
  bool isDark = false;

  ControlBloc() : super(ControlInitialState()) {
    on<ChangeThemeEvent>(onChangeThemeEvent);
  }

  onChangeThemeEvent(event, emit) async {
    isDark = !isDark;
    emit(ChangeThemeState(isDark));
  }

  onSomeEvent(event, emit) async {
    try {
      //
    } catch (error) {
      //
    }
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

// Events ------------------------------------
abstract class ControlEvent {}

class ChangeThemeEvent extends ControlEvent {}

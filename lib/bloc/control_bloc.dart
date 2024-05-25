import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ControlBloc extends Bloc<ControlEvent, ControlState> {
  final Box settingsBox = Hive.box('settingsBox');

  // для переключения тем запись и чтение
  bool get isIpUse => settingsBox.get('isIpUse', defaultValue: false);
  set isIpUse(bool value) => settingsBox.put('isIpUse', value);

  // для переключения тем запись и чтение
  bool get isDark => settingsBox.get('isDark', defaultValue: true);
  set isDark(bool value) => settingsBox.put('isDark', value);

  // для обновления данных инструментов запись и чтение
  bool get isInstrumentsDataUpdated =>
      settingsBox.get('isInstrumentsDataUpdated', defaultValue: false);
  set isInstrumentsDataUpdated(bool value) =>
      settingsBox.put('isInstrumentsDataUpdated', value);

  // для канала вебсоккетов чтение и сохранение
  String get wsIp => settingsBox.get('wsIp', defaultValue: "192.168.0.5:33333");
  set wsIp(String value) => settingsBox.put('wsIp', value);

  // Инициализация класса блока
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

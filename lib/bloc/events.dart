import 'data_classes.dart';

abstract class MainEvent {}

class ThemeSwitchEvent extends MainEvent {}

// Main Events
class MainSetAppBarTitleEvent extends MainEvent {
  String title;
  MainSetAppBarTitleEvent(this.title);
}

class MainSetThemeEvent extends MainEvent {}

// Pulse Events
class GetPulseEvent extends MainEvent {}

class PulseSearchEvent extends MainEvent {
  String search;
  List<Pulse> pulses;
  PulseSearchEvent(this.search, this.pulses);
}

// Analytics Events
class AnalyticsDataLoadEvent extends MainEvent {}

// Active Events
class GetActiveEvent extends MainEvent {}

class ActiveSearchEvent extends MainEvent {
  String search;
  List<Instrument> instruments;
  ActiveSearchEvent(this.search, this.instruments);
}

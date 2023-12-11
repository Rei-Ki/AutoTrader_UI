import 'data_classes.dart';

abstract class Event {}

// Main Events
class MainSetAppBarTitleEvent extends Event {
  String title;
  MainSetAppBarTitleEvent(this.title);
}

class MainSetThemeEvent extends Event {}

// Pulse Events
class GetPulseEvent extends Event {}

class PulseSearchEvent extends Event {
  String search;
  List<Pulse> pulses;
  PulseSearchEvent(this.search, this.pulses);
}

// Analytics Events
class AnalyticsDataLoadEvent extends Event {}

// Active Events
class GetActiveEvent extends Event {}

class ActiveSearchEvent extends Event {
  String search;
  List<Instrument> instruments;
  ActiveSearchEvent(this.search, this.instruments);
}

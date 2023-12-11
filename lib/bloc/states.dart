import 'data_classes.dart';

abstract class MainState {}

// base States
class InitialState extends MainState {}

class ErrorState extends MainState {}

// Pulse States
class PulseInitialState extends MainState {}

class PulseLoadingState extends MainState {}

class PulseLoadedState extends MainState {
  List<Pulse> pulses;
  PulseLoadedState(this.pulses);
}

class PulseSearchingState extends MainState {
  List<Pulse> searched;
  PulseSearchingState(this.searched);
}

// Main States
class MainAppBarUpdatedState extends MainState {
  String title;
  MainAppBarUpdatedState(this.title);
}

// class MainChangeActive extends State {}
// class MainChangePulse extends State {}
// class MainChangeAnalytics extends State {}

// Analytics States
class AnalyticsInitialState extends MainState {}

class AnalyticsLoadingState extends MainState {}

class AnalyticsLoadedState extends MainState {
  List<Segment> segments;
  AnalyticsLoadedState(this.segments);
}

// Active States
class ActiveInitialState extends MainState {}

class ActiveLoadingState extends MainState {}

class ActiveLoadedState extends MainState {
  List<Instrument> instruments;
  ActiveLoadedState(this.instruments);
}

class ActiveSearchingState extends MainState {
  List<Instrument> searched;
  ActiveSearchingState(this.searched);
}

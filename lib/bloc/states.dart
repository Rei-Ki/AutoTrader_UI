import 'data_classes.dart';

abstract class MainState {}

class MainActiveState extends MainState {}

class MainPulseState extends MainState {}

class MainAnalyticsState extends MainState {}

// Pulse States
class PulseInitialState extends MainState {}

class PulseLoadingState extends MainState {}

class PulseLoadedState extends MainState {
  List<Pulse> pulses;
  PulseLoadedState(this.pulses);
}

class PulseErrorState extends MainState {}

class PulseSearchingState extends MainState {
  List<Pulse> searched;
  PulseSearchingState(this.searched);
}

// Main States
class InitialState extends MainState {}

class MainAppBarUpdatedState extends MainState {
  String title;
  MainAppBarUpdatedState(this.title);
}

// class MainChangeActive extends State {}
// class MainChangePulse extends State {}
// class MainChangeAnalytics extends State {}
class MainErrorState extends MainState {}

// Analytics States
class AnalyticsInitialState extends MainState {}

class AnalyticsLoadingState extends MainState {}

class AnalyticsLoadedState extends MainState {
  List<Segment> segments;
  AnalyticsLoadedState(this.segments);
}

class AnalyticsErrorState extends MainState {}

// Active States
class ActiveInitialState extends MainState {}

class ActiveLoadingState extends MainState {}

class ActiveErrorState extends MainState {}

class ActiveLoadedState extends MainState {
  List<Instrument> instruments;
  ActiveLoadedState(this.instruments);
}

class ActiveSearchingState extends MainState {
  List<Instrument> searched;
  ActiveSearchingState(this.searched);
}

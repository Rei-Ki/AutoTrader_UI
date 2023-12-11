import 'data_classes.dart';

abstract class State {}

class InitialState extends State {}

// Pulse States
class PulseInitialState extends State {}

class PulseLoadingState extends State {}

class PulseLoadedState extends State {
  List<Pulse> pulses;
  PulseLoadedState(this.pulses);
}

class PulseErrorState extends State {}

class PulseSearchingState extends State {
  List<Pulse> searched;
  PulseSearchingState(this.searched);
}

// Main States
class MainInitialState extends State {}

class MainAppBarUpdatedState extends State {
  String title;
  MainAppBarUpdatedState(this.title);
}

// class MainChangeActive extends State {}
// class MainChangePulse extends State {}
// class MainChangeAnalytics extends State {}
class MainErrorState extends State {}

// Analytics States
class AnalyticsInitialState extends State {}

class AnalyticsLoadingState extends State {}

class AnalyticsLoadedState extends State {
  List<Segment> segments;
  AnalyticsLoadedState(this.segments);
}

class AnalyticsErrorState extends State {}

// Active States
class ActiveInitialState extends State {}

class ActiveLoadingState extends State {}

class ActiveErrorState extends State {}

class ActiveLoadedState extends State {
  List<Instrument> instruments;
  ActiveLoadedState(this.instruments);
}

class ActiveSearchingState extends State {
  List<Instrument> searched;
  ActiveSearchingState(this.searched);
}

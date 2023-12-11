import 'package:flutter_bloc/flutter_bloc.dart';
import 'data_classes.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  AnalyticsBloc() : super(AnalyticsInitialState()) {
    on<AnalyticsDataLoadEvent>(loadData);
  }

  loadData(event, emit) async {
    try {
      emit(AnalyticsLoadingState());

      List<Segment> segments = await getServerSegmentsData();

      emit(AnalyticsLoadedState(segments));
    } catch (error) {
      emit(AnalyticsErrorState());
    }
  }

  // other functions
  getServerSegmentsData() async {
    await Future.delayed(const Duration(microseconds: 1));
    List<Segment> segments = [
      Segment(name: "AAPL", value: 1500),
      Segment(name: "GOOGL", value: 2000),
      Segment(name: "MSFT", value: 1200),
      Segment(name: "AMZN", value: 1800),
      Segment(name: "FB", value: 2500),
      Segment(name: "JPM", value: 1600),
      Segment(name: "XOM", value: 3000),
      Segment(name: "Свободные", value: 4200),
    ];

    return segments;
  }
}

// States ------------------------------------
abstract class AnalyticsState {}

class AnalyticsInitialState extends AnalyticsState {}

class AnalyticsLoadingState extends AnalyticsState {}

class AnalyticsLoadedState extends AnalyticsState {
  List<Segment> segments;
  AnalyticsLoadedState(this.segments);
}

class AnalyticsErrorState extends AnalyticsState {}

// Events ------------------------------------
abstract class AnalyticsEvent {}

class AnalyticsDataLoadEvent extends AnalyticsEvent {}

import 'package:flutter_bloc/flutter_bloc.dart';

part 'some_event.dart';
part 'some_state.dart';

class SomeBloc extends Bloc<SomeEvent, SomeState> {
  SomeBloc() : super(SomeInitial()) {
    on<LoadSomething>((event, emit) {
      print("LoadSomething...");
    });
  }
}

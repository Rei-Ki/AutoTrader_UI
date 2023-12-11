import 'package:flutter_bloc/flutter_bloc.dart';

class SomeBloc extends Bloc<SomeEvent, SomeState> {
  SomeBloc() : super(SomeInitialState()) {
    on<SomeTEvent>(someT);
  }

  someT(event, emit) async {
    try {
      //
    } catch (error) {
      //
    }
  }

  // other functions
  get() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}

// States ------------------------------------
abstract class SomeState {}

class SomeInitialState extends SomeState {}

class SomeLoadingState extends SomeState {}

class SomeLoadedState extends SomeState {}

class SomeErrorState extends SomeState {}

// Events ------------------------------------
abstract class SomeEvent {}

class SomeTEvent extends SomeEvent {}

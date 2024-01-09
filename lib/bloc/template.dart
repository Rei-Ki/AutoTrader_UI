import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class SomeBloc extends Bloc<SomeEvent, SomeState> {
  SomeBloc() : super(SomeInitialState()) {
    on<SomeTEvent>(someT);
  }

  someT(event, emit) async {
    try {
      //
    } catch (e, st) {
      //
      GetIt.I<Talker>().error(e, st);
    }
  }

  // other functions
  get() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().error(error, stackTrace);
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

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final loginResultController = StreamController<bool>.broadcast();

  // todo ДОВЕСТИ ДО УМА ЕГО

  // bool isLogged = false;
  bool isLogged = true;

  LoginBloc() : super(LoginInitialState()) {
    on<StartLoginEvent>(onStartLogin);
  }

  onStartLogin(event, emit) async {
    try {
      String password = event.password;
      String username = event.username;

      isLogged = true;
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
    }

    loginResultController.add(isLogged);
  }

  Stream<bool> get loginResultStream => loginResultController.stream;

  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is StartLoginEvent) {
      loginResultController.add(isLogged);
    }
  }

  @override
  Future<void> close() {
    loginResultController.close();
    return super.close();
  }
}

// States ------------------------------------
abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginErrorState extends LoginState {}

// Events ------------------------------------
abstract class LoginEvent {}

class StartLoginEvent extends LoginEvent {
  String password;
  String username;
  StartLoginEvent({required this.password, required this.username});
}

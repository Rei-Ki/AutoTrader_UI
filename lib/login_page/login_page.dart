import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotosui/bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.bloc,
  });

  final LoginBloc bloc;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Вход'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text('LoginPage'),
            ElevatedButton(
              onPressed: () {
                widget.bloc
                    .add(StartLoginEvent(password: "pass", username: "name"));
              },
              child: const Text("Login"),
            )
          ],
        ),
      ),
    );
  }
}

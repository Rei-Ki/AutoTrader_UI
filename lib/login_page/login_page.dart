import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotosui/login_page/login_bloc.dart';

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
  TextEditingController login = TextEditingController();
  TextEditingController password = TextEditingController();
  late double screenWidth;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.8;
    screenWidth = screenWidth < 300 ? screenWidth : 300;
    screenWidth = screenWidth > 200 ? screenWidth : 200;

    return BlocProvider.value(
      value: widget.bloc,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: screenWidth,
                child: Column(
                  children: [
                    Text(
                      'Авторизация',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 35),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: login,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: const InputDecoration(
                        hintText: "логин",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: password,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: const InputDecoration(
                        hintText: "пароль",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.pink,
                side: BorderSide.none,
              ),
              onPressed: () {
                widget.bloc
                    .add(StartLoginEvent(password: "pass", username: "name"));
              },
              child: Container(
                width: screenWidth - 45,
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "Войти",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white, fontSize: 22),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

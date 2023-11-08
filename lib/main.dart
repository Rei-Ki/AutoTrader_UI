import 'dart:developer';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,

        dividerColor: Colors.transparent,

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black12,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.w500,
          )
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.black,
        ),

        textTheme: const TextTheme(
            bodyMedium: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            labelSmall: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w200,
            )
        )
      ),
      // home: LotosHome(title: 'Lotos UI'),
      initialRoute: '/main',
      routes: {
        '/main' : (context) => LotosHome(title: 'Lotos UI'),
        '/some': (context) => LotosSome(),
      },
    );
  }
}

class LotosHome extends StatefulWidget {
  const LotosHome({super.key, required this.title});

  final String title;

  @override
  State<LotosHome> createState() => _LotosHomeState();
}

class _LotosHomeState extends State<LotosHome> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, i) {
          final instrumentName = "instrument";

          return ListTile(
            leading: const Icon(Icons.co_present_outlined, size: 30),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            title: Text(
              instrumentName,
              style: theme.textTheme.bodyMedium,
            ),
            subtitle: Text(
              "Тип: Фьючерс",
              style: theme.textTheme.labelSmall,
            ),
            onTap: () {
              Navigator.of(context).pushNamed(
                '/some',
                arguments: instrumentName,
              );
            },
          );
        }
      ),
    );
  }
}

class LotosSome extends StatefulWidget {
  const LotosSome({super.key});

  @override
  State<LotosSome> createState() => _LotosSomeState();
}

class _LotosSomeState extends State<LotosSome> {
  String? title;

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    assert(args != null && args is String, "You mast provide String args");

    title = args as String;
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? '...'),
      ),
    );
  }
}


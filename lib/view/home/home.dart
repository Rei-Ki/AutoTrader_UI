import 'package:flutter/material.dart';
import 'package:lotosui/bloc/some_bloc.dart';

class LotosHome extends StatefulWidget {
  const LotosHome({super.key, required this.title});

  final String title;

  @override
  State<LotosHome> createState() => _LotosHomeState();
}

class _LotosHomeState extends State<LotosHome> {
  final _someInstanceBloc = SomeBloc();

  @override
  void initState() {
    _someInstanceBloc.add(LoadSomething());
    super.initState();
  }

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
            const instrumentName = "instrument";

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
          }),
    );
  }
}

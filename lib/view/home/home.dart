import 'package:flutter/material.dart';
import 'package:lotosui/bloc/some_bloc.dart';
import 'package:lotosui/variables.dart';
import 'package:lotosui/view/home/nav_bar.dart';

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
    final instrumentsInfo = instruments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      bottomNavigationBar: navBar,
      // ignore: unnecessary_null_comparison
      body: (instrumentsInfo == null)
          ? const SizedBox()
          : ListView.builder(
              itemCount: instrumentsInfo.length,
              itemBuilder: (context, i) {
                final instrumentName = instrumentsInfo[i];

                return InstrumentTileWidget(
                    instrumentName: instrumentName, theme: theme);
              }),
    );
  }
}

class InstrumentTileWidget extends StatelessWidget {
  const InstrumentTileWidget({
    super.key,
    required this.instrumentName,
    required this.theme,
  });

  final String instrumentName;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.data_usage_rounded, size: 30),
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
}

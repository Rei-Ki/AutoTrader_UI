import 'package:flutter/material.dart';

class Instruments extends StatefulWidget {
  const Instruments({super.key});

  @override
  State<Instruments> createState() => _InstrumentsState();
}

class _InstrumentsState extends State<Instruments> {
  // todo Можно сделать еще и JSON файлом
  List instruments = [
    ["CRU3", "Фьючерс"],
    ["CRZ3", "Фьючерс"],
    ["SiU3", "Фьючерс"],
    ["SiZ3", "Фьючерс"],
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: instruments.length,
      itemBuilder: (context, i) {
        return InstrumentTile(
          instrumentName: instruments[i][0],
          instrumentType: instruments[i][1],
        );
      },
    );
  }
}

class InstrumentTile extends StatelessWidget {
  const InstrumentTile({
    super.key,
    required this.instrumentName,
    required this.instrumentType,
  });

  final String instrumentName;
  final String instrumentType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: const Icon(Icons.data_usage_rounded, size: 30),
          title: Text(
            instrumentName,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          subtitle: Text(
            "Тип: $instrumentType",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              '/instrumentInfo',
              arguments: instrumentName,
            );
          },
        ),
      ),
    );
  }
}

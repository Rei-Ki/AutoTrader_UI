import 'package:flutter/material.dart';
import 'package:lotosui/widgets/tiles/active_tile.dart';

class ActiveList extends StatefulWidget {
  const ActiveList({super.key, required this.filter});

  final String filter;

  @override
  State<ActiveList> createState() => _ActiveListState();
}

class _ActiveListState extends State<ActiveList> {
  // todo Можно сделать еще и JSON файлом
  // todo Сделать чтобы оно обновлялось при изменении фильтра а не при пересохранении
  List instruments = [
    ["CRU3", "Фьючерс", true],
    ["CRZ3", "Фьючерс", true],
    ["SiU3", "Фьючерс", false],
    ["SiZ3", "Фьючерс", false],
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: getFiltredList(filter: widget.filter).length,
      itemBuilder: (context, i) {
        return ActiveTile(
          instrumentName: getFiltredList(filter: widget.filter)[i][0],
          instrumentType: getFiltredList(filter: widget.filter)[i][1],
        );
      },
    );
  }

  getFiltredList({required String filter}) {
    if (filter.isNotEmpty) {
      return instruments
          .where((element) => element[0].contains(filter))
          .toList();
    }
    return instruments;
  }
}

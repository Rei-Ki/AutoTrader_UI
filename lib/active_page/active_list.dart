import 'package:flutter/material.dart';
import 'package:lotosui/bloc/data_classes.dart';

class ActiveList extends StatefulWidget {
  const ActiveList({super.key, required this.filter});

  final String filter;

  @override
  State<ActiveList> createState() => _ActiveListState();
}

class _ActiveListState extends State<ActiveList> {
  // todo Можно сделать еще и JSON файлом
  // todo Сделать чтобы оно обновлялось при изменении фильтра а не при пересохранении
  List<InstrumentData> instruments = [
    InstrumentData(title: "CRU3", type: "Фьючерс", isActive: true),
    InstrumentData(title: "CRZ3", type: "Фьючерс", isActive: true),
    InstrumentData(title: "SiU3", type: "Фьючерс", isActive: false),
    InstrumentData(title: "SiZ3", type: "Фьючерс", isActive: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: getFiltredList(filter: widget.filter).length,
        itemBuilder: (context, i) {
          return ActiveTile(
            data: instruments[i],
          );
        },
      ),
    );
  }

  getFiltredList({required String filter}) {
    if (filter.isNotEmpty) {
      return instruments
          .where((element) => element.title.contains(filter))
          .toList();
    }
    return instruments;
  }
}

// Плитка
class ActiveTile extends StatelessWidget {
  const ActiveTile({
    super.key,
    required this.data,
  });

  final InstrumentData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: const Icon(Icons.data_usage_rounded, size: 29),
          trailing: const Icon(Icons.more_vert_rounded, size: 27),
          title: Text(
            data.title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          subtitle: Text(
            "Тип: ${data.type}",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              '/instrumentInfo',
              arguments: data.title,
            );
          },
        ),
      ),
    );
  }
}

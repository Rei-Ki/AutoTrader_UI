import 'package:lotosui/bloc/data_classes.dart';
import 'package:lotosui/widgets/tiles/pulse_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PulseList extends StatefulWidget {
  const PulseList({super.key});

  @override
  State<PulseList> createState() => _PulseListState();
}

class _PulseListState extends State<PulseList> {
  // todo Добавить такой же для активных
  List<PulseData> pulse = [
    PulseData(
      title: 'Инструмент 0',
      operation: "покупка",
      date: DateFormat('dd.MM.yy\nkk:mm').format(DateTime.now()),
      price: 100,
      quantity: 2,
    ),
    PulseData(
      title: 'Инструмент 1',
      operation: "покупка",
      date: DateFormat('dd.MM.yy\nkk:mm').format(DateTime.now()),
      price: 200,
      quantity: 4,
    ),
    PulseData(
      title: 'Инструмент 2',
      operation: "продажа",
      date: DateFormat('dd.MM.yy\nkk:mm').format(DateTime.now()),
      price: 130,
      quantity: 1,
    ),
    PulseData(
      title: 'Инструмент 3',
      operation: "продажа",
      date: DateFormat('dd.MM.yy\nkk:mm').format(DateTime.now()),
      price: 150,
      quantity: 1,
    ),
    PulseData(
      title: 'Инструмент 4',
      operation: "продажа",
      date: DateFormat('dd.MM.yy\nkk:mm').format(DateTime.now()),
      price: 110,
      quantity: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pulse.length,
      itemBuilder: (context, index) {
        return PulseTile(
          data: inversePulse()[index],
        );
      },
    );
  }

  List<PulseData> inversePulse() {
    return pulse.reversed.toList();
  }
}

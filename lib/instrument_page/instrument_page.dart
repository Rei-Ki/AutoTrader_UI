import 'package:lotosui/instrument_page/instrument_plot.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:flutter/material.dart';
// import 'dart:async';

class InstrumentPage extends StatefulWidget {
  const InstrumentPage({super.key});

  @override
  State<InstrumentPage> createState() => _InstrumentPageState();
}

class _InstrumentPageState extends State<InstrumentPage> {
  String? title;
  int selectedStrategy = 0;
  int selectedTimeframe = 4;
  List<String> strategies = ["fractal", "corridor"];
  TextEditingController risk = TextEditingController();
  TextEditingController planLimit = TextEditingController();
  List<String> timeFrames = [
    '1m',
    '5m',
    '15m',
    '30m',
    '60m',
    '2h',
    '4h',
    '1D',
    '1W',
    // '1MN'
  ];

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(title ?? '...'),
      ),
      body: Column(
        children: [
          Plot(
            selectedTimeframe: selectedTimeframe,
            timeFrames: timeFrames,
          ),
          inputFields(),
          strategyTabs(context),
          startButton(context)
        ],
      ),
    );
  }

  Widget inputFields() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: risk,
              decoration: const InputDecoration(
                hintText: "% допустимого риска (Базовое 20%)",
                hintStyle: TextStyle(fontSize: 14),
              ),
            ),
            TextField(
              controller: planLimit,
              decoration: const InputDecoration(
                hintText: "Лимит план. чистых позиций (Базовое: 10000)",
                hintStyle: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconButton startButton(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      onPressed: () {
        // todo сделать анимацию переключения состояния кнопки
        // todo сделать сокрытие стратегий
        // todo сделать отправку на сервер

        Map<String, dynamic> data = {
          "cmd": "start_instrument",
          "data": {
            "sec_code": title,
            "interval": selectedTimeframe,
            "strategy": strategies[selectedStrategy],
            "risk": risk.text,
            "plan_limit": planLimit.text,
          },
        };
        print(data);
      },
      icon: Icon(
        Icons.play_arrow_outlined,
        size: 70,
        color: Theme.of(context).primaryColor.withOpacity(0.8),
      ),
    );
  }

  Widget strategyTabs(BuildContext context) {
    return FlutterToggleTab(
      width: 60, // width in percent
      borderRadius: 50,
      height: 35,
      selectedIndex: selectedStrategy,
      unSelectedBackgroundColors: const [Colors.white],
      selectedBackgroundColors: [
        Theme.of(context).primaryColor.withOpacity(0.7)
      ],
      selectedTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
      unSelectedTextStyle: const TextStyle(color: Colors.black, fontSize: 14),
      labels: strategies,
      selectedLabelIndex: (index) {
        setState(() {
          selectedStrategy = index;
          // todo сделать чтобы после старта пропадал этот свитчер
          print(strategies[index]);
        });
      },
    );
  }
}

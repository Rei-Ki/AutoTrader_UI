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

  @override
  void didChangeDependencies() {
    // final args = ModalRoute.of(context)?.settings.arguments;
    // todo сделать смену страниц через блок
    // title = args as String;
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // return BlocProvider(
    //   create: (context) => MainBloc(),
    //   child: buildInstrumentPageBloc(context),
    // );
    return buildInstrumentPage(context);
  }

  Scaffold buildInstrumentPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title ?? 'Инструмент не выбран')),
      body: Column(
        children: [
          const Plot(),
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

  Widget strategyTabs(BuildContext context) {
    return FlutterToggleTab(
      width: 60, // width in percent
      borderRadius: 50,
      height: 35,
      selectedIndex: selectedStrategy,
      unSelectedBackgroundColors: [Theme.of(context).scaffoldBackgroundColor],
      selectedBackgroundColors: [
        Theme.of(context).primaryColor.withOpacity(0.7)
      ],
      selectedTextStyle: const TextStyle(color: Colors.black, fontSize: 14),
      unSelectedTextStyle: const TextStyle(fontSize: 14),
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

  IconButton startButton(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      onPressed: () {
        // todo сделать анимацию переключения состояния кнопки
        // todo сделать сокрытие стратегий
        // todo сделать отправку на сервер

        // Map<String, dynamic> data = {
        //   "cmd": "start_instrument",
        //   "data": {
        //     "sec_code": title,
        //     "interval": selectedTimeframe,
        //     "strategy": strategies[selectedStrategy],
        //     "risk": risk.text,
        //     "plan_limit": planLimit.text,
        //   },
        // };
        // print(data);
      },
      icon: Icon(
        Icons.play_arrow_outlined,
        size: 70,
        color: Theme.of(context).primaryColor.withOpacity(0.8),
      ),
    );
  }
}

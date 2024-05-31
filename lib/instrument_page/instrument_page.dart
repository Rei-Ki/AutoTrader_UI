import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotosui/instrument_page/instrument_plot.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:flutter/material.dart';

import '../bloc/data_classes.dart';
import 'instrument_bloc.dart';

class InstrumentPage extends StatefulWidget {
  const InstrumentPage({super.key});

  @override
  State<InstrumentPage> createState() => _InstrumentPageState();
}

class _InstrumentPageState extends State<InstrumentPage> {
  int selectedStrategy = 0;
  SwiperController swiperController = SwiperController();

  List<String> strategies = [
    "fractal",
    // "corridor",
  ];
  TextEditingController risk = TextEditingController();
  TextEditingController planLimit = TextEditingController();
  late InstrumentBloc instrumentBloc;
  // TODO 1 сделать отображение какой таймфрейм запущен
  // FIXME 1 Посмотреть какая то ошибка при запуске "Error: 'SiM4'"

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args != null) {
      instrumentBloc = args as InstrumentBloc;
    } else {
      Instrument data = Instrument(title: "None", tags: {}, type: "None");
      instrumentBloc = InstrumentBloc(data: data);
    }

    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: instrumentBloc,
      child: Scaffold(
        appBar: AppBar(title: Text(instrumentBloc.data.title)),
        floatingActionButton: createFAB(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: buildInstrumentBloc(),
      ),
    );
  }

  FloatingActionButton createFAB(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.transparent,
      onPressed: () => showModalDialog(context),
      elevation: 0,
      hoverElevation: 0,
      label: Icon(
        Icons.play_arrow_outlined,
        size: 80, // Размер иконки
        color: Theme.of(context).primaryColor.withOpacity(0.8),
      ),
    );
  }

  buildInstrumentBloc() {
    return BlocBuilder<InstrumentBloc, InstrumentState>(
      builder: (context, state) {
        if (state is InstrumentInitialState) {
          // TODO сделать как то интервал по-умолчанию
          instrumentBloc.add(UpdatePlotDataEvent("1m"));

          return buildInstrumentColumn(context, []);
        }

        if (state is UpdatePlotDataState) {
          return buildInstrumentColumn(context, state.candles);
        }

        return Center(
          child: Text(
            "Ooops, something went wrong (instrument)",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      },
    );
  }

  buildInstrumentColumn(BuildContext context, List<Candle> candles) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Plot(
          swiperController: swiperController,
          candles: candles,
          bloc: instrumentBloc,
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  showModalDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              inputFields(),
              const SizedBox(height: 25),
              strategyTabs(context),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // NOTE отправка сообщения серверу о старте инструмента
                instrumentBloc.add(
                  StartInstrument(
                      secCode: instrumentBloc.data.title,
                      interval: instrumentBloc.currentTimeframe,
                      strategy: strategies[selectedStrategy],
                      risk: risk.text,
                      planLimit: planLimit.text),
                );
              },
              child: const Text('Старт'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалоговое окно
              },
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }

  Widget inputFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          Text(
            "% допустимого риска",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          TextField(
            controller: risk,
            decoration: const InputDecoration(
              hintText: "базовое: 20%",
            ),
          ),
          const SizedBox(height: 30),
          Text(
            "лимит чистых позиций",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          TextField(
            controller: planLimit,
            decoration: const InputDecoration(
              hintText: "базовое: 10000",
            ),
          ),
        ],
      ),
    );
  }

  Widget strategyTabs(BuildContext context) {
    return Text("${strategies[0]} strategy");
    // return FlutterToggleTab(
    //   width: 60, // width in percent
    //   borderRadius: 50,
    //   height: 35,
    //   selectedIndex: selectedStrategy,
    //   unSelectedBackgroundColors: [Theme.of(context).scaffoldBackgroundColor],
    //   selectedBackgroundColors: [
    //     Theme.of(context).primaryColor.withOpacity(0.7),
    //   ],
    //   selectedTextStyle: const TextStyle(color: Colors.black, fontSize: 14),
    //   unSelectedTextStyle: const TextStyle(fontSize: 14),
    //   labels: strategies,
    //   selectedLabelIndex: (index) {
    //     selectedStrategy = index;
    //     setState(() {});
    //     print(strategies[index]);
    //   },
    // );
  }

  IconButton startButton(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      onPressed: () {
        // TODO 1 сделать тут блок и в нем все это обрабатывать
        // TODO 1 сделать анимацию переключения состояния кнопки
        // TODO 1 сделать сокрытие стратегий
        // TODO 1 сделать отправку на сервер

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
        // print("23123123");
      },
      icon: Icon(
        Icons.play_arrow_outlined,
        size: 70,
        color: Theme.of(context).primaryColor.withOpacity(0.8),
      ),
    );
  }
}

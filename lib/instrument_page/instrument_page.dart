import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotosui/instrument_page/instrument_plot.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:flutter/material.dart';

import '../bloc/data_classes.dart';
import 'instrument_bloc.dart';
// import 'dart:async';

class InstrumentPage extends StatefulWidget {
  const InstrumentPage({super.key});

  @override
  State<InstrumentPage> createState() => _InstrumentPageState();
}

class _InstrumentPageState extends State<InstrumentPage> {
  int selectedStrategy = 0;
  //! todo прокинуть в таймфреймы контроллер свайпа
  SwiperController swiperController = SwiperController();
  int selectedTimeframe = 4;

  List<String> strategies = ["fractal strategy", "corridor strategy"];
  TextEditingController risk = TextEditingController();
  TextEditingController planLimit = TextEditingController();
  late InstrumentBloc instrumentBloc;

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args != null) {
      instrumentBloc = args as InstrumentBloc;
    } else {
      Instrument data = Instrument(title: "None", tags: [], type: "None");
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
      onPressed: () => showModalDialog(context),
      elevation: 0,
      hoverElevation: 0,
      label: Icon(
        Icons.play_arrow_outlined,
        size: 60, // Размер иконки
        color: Theme.of(context).primaryColor.withOpacity(0.8),
      ),
    );
  }

  //! todo сделать что бы данные обновлялись без передачи а просто watch

  BlocBuilder<dynamic, dynamic> buildInstrumentBloc() {
    return BlocBuilder<InstrumentBloc, InstrumentState>(
      builder: (context, state) {
        if (state is InstrumentInitialState) {
          instrumentBloc.add(UpdatePlotDataEvent());

          return buildInstrumentColumn(context);
        }

        if (state is UpdatePlotDataState) {
          return buildInstrumentColumn(context);
        }

        return const Center(
            child: Text("Ooops, something went wrong (instrument)"));
      },
    );
  }

  buildInstrumentColumn(BuildContext context) {
    List<Candle> candlesAll = context.watch<InstrumentBloc>().candles;

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Plot(
                  swiperController: swiperController,
                  bloc: instrumentBloc,
                  candles: candlesAll),
            ],
          ),
        ),
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
          const Text("% допустимого риска"),
          TextField(
            controller: risk,
            decoration: const InputDecoration(
              hintText: "базовое: 20%",
            ),
          ),
          const SizedBox(height: 30),
          const Text("лимит чистых позиций"),
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

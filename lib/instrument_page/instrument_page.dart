import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotosui/instrument_page/instrument_plot.dart';
// import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
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
  // сначала запрос, потом отстройка интерфейса, потом уже в руки пользователя действия
  // TODO подумать что будет с инструментом когда закроется страница с этим инструментом
  // то есть надо подтягивать данные из сервера, какие запущенные и подобное

  // TODO 1 сделать отображение какой таймфрейм запущен
  // FIXME 1 Посмотреть какая то ошибка при запуске "Error: 'SiM4'"

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args != null) {
      instrumentBloc = args as InstrumentBloc;
    } else {
      Instrument data =
          Instrument(title: "None", tags: {}, type: "None", activeInterval: {});
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

  buildInstrumentBloc() {
    return BlocBuilder<InstrumentBloc, InstrumentState>(
      builder: (context, state) {
        if (state is InstrumentInitialState) {
          // TODO сделать как то интервал по-умолчанию
          instrumentBloc.add(UpdatePlotDataEvent("1m"));

          // List<String> arr = ["123", "2123", "345"];
          return buildInstrumentColumn(context, []);
        }

        if (state is UpdatePlotDataState) {
          return buildInstrumentColumn(context, state.candles);
        }
        // TODO создать запрос к серверу для предоставления активных инструментов и их таймфреймов

        return Center(
          child: Text(
            "Ooops, something went wrong (instrument)",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      },
    );
  }

  buildInstrumentColumn(BuildContext context, List<Candle> candles,
      [List<String>? activeData]) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Plot(
            swiperController: swiperController,
            candles: candles,
            bloc: instrumentBloc,
          ),
          const SizedBox(height: 10),
          // Cписок с запущенными инструментами
          activeList(context),
        ],
      ),
    );
  }

  Widget activeList(BuildContext context) {
    String title = context.read<InstrumentBloc>().data.title;
    var activeInterval = context.watch<InstrumentBloc>().data.activeInterval;
    return Column(
      children: activeInterval
          .map<Widget>(
            (interval) => Text("$title | $interval"),
          )
          .toList(),
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
                // отправка сообщения серверу о старте инструмента
                instrumentBloc.add(
                  // TODO сделать проверку есть ли уже в активных такая заявка (название инструмента и таймфрейм)
                  StartInstrument(
                    secCode: instrumentBloc.data.title,
                    interval: instrumentBloc.currentInterval,
                    strategy: strategies[selectedStrategy],
                    risk: risk.text,
                    planLimit: planLimit.text,
                  ),
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
}

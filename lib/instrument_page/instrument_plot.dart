import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotosui/instrument_page/instrument_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math' as math;

import '../bloc/data_classes.dart';

// ignore: must_be_immutable
class Plot extends StatefulWidget {
  const Plot({
    super.key,
    required this.bloc,
    required this.candles,
  });

  final List<Candle> candles;
  final InstrumentBloc bloc;

  @override
  State<Plot> createState() => _PlotState();
}

class _PlotState extends State<Plot> {
  late ChartSeriesController chartSeriesController;
  late ZoomPanBehavior zoomPanBehavior;
  int selectedTimeframe = 4;
  SwiperController swiperController = SwiperController();
  List<Color> colorList = [];
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
    '1M'
  ];

  // todo возможно обработка данных сломана

  // todo Сделать выбор таймфреймов выпадающим списком и поместить его к цене

  @override
  void initState() {
    zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enableMouseWheelZooming: true,
      enableDoubleTapZooming: true,
      enableSelectionZooming: true,
      enablePanning: true,
    );
    super.initState();

    // print(widget.candles);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          buildTopPanel(),
          // График --------------------------------
          buildChart(context),
          // timeframes ---------------------------------------------------------------
          buildTimeframes(timeFrames)
        ],
      ),
    );
  }

  Row buildTopPanel() {
    var lastCandle =
        widget.candles.isNotEmpty ? widget.candles.last.close : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          lastCandle!.toStringAsFixed(3),
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  SfCartesianChart buildChart(BuildContext context) {
    return SfCartesianChart(
      zoomPanBehavior: zoomPanBehavior,
      margin: const EdgeInsets.only(left: 8, right: 4),
      series: <ChartSeries<Candle, int>>[
        AreaSeries<Candle, int>(
          onRendererCreated: (ChartSeriesController controller) {
            chartSeriesController = controller;
          },
          borderWidth: 3,
          borderColor: Theme.of(context).primaryColor.withOpacity(0.7),
          gradient: LinearGradient(
            transform: const GradientRotation(math.pi / 2),
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.5),
              Theme.of(context).primaryColor.withOpacity(0.2),
              Colors.transparent,
            ],
          ),
          dataSource: context.watch<InstrumentBloc>().candles,
          xValueMapper: (Candle data, int index) => data.time,
          yValueMapper: (Candle data, int index) => data.close,
          animationDuration: 800,
          animationDelay: 400,
          markerSettings: MarkerSettings(
            isVisible: true,
            borderColor: Theme.of(context).primaryColor.withOpacity(0.7),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        )
      ],
      primaryXAxis: getPrimaryXAxis(),
      primaryYAxis: getPrimaryYAxis(),
    );
  }

  buildTimeframes(timeFrames) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: SizedBox(
            height: 30,
            child: Swiper(
              onTap: (value) => swiperController.move(value),
              itemCount: timeFrames.length,
              allowImplicitScrolling: true,
              scale: 0.3,
              layout: SwiperLayout.DEFAULT,
              control: const SwiperControl(),
              controller: swiperController,
              onIndexChanged: (value) {
                swiperController.index = value;
              },
              viewportFraction: 0.1,
              itemBuilder: (context, i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: getColor(i, timeFrames.length),
                  ),
                  child: Center(
                    child: swiperController.index == i
                        ? Text(timeFrames[i].toString(),
                            style: const TextStyle(color: Colors.white))
                        : Text(timeFrames[i].toString()),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  int getTime(String timeFrameString) {
    int timeFrame = getDigitsFromString(timeFrameString);

    if (timeFrameString.contains("m")) {
      return timeFrame;
    }
    if (timeFrameString.contains("h")) {
      return timeFrame * 60;
    }
    if (timeFrameString.contains("D")) {
      return timeFrame * 60 * 24;
    }
    if (timeFrameString.contains("W")) {
      // todo не совсем уверен в том что неделя там именно 7
      return timeFrame * 60 * 24 * 7;
    }
    if (timeFrameString.contains("M")) {
      // todo не совсем уверен в том что месяц именно 30
      return timeFrame * 60 * 24 * 30;
    }
    return 60; // возвращение по стандарту часового интервала
  }

  int getDigitsFromString(String input) {
    RegExp regex = RegExp(r'\d+');
    Iterable<RegExpMatch> matches = regex.allMatches(input);
    return int.parse(matches.map((match) => match.group(0)!).join());
  }

  NumericAxis getPrimaryXAxis() {
    return NumericAxis(
      majorGridLines: const MajorGridLines(width: 1),
      edgeLabelPlacement: EdgeLabelPlacement.shift,
      interval: 2,
      title: AxisTitle(text: ''),
      decimalPlaces: 0,
      labelPosition: ChartDataLabelPosition.outside,
    );
  }

  NumericAxis getPrimaryYAxis() {
    return NumericAxis(
      opposedPosition: true,
      axisLine: const AxisLine(width: 0),
      enableAutoIntervalOnZooming: true,
      title: AxisTitle(text: ''),
      decimalPlaces: 3,
      labelPosition: ChartDataLabelPosition.outside,
    );
  }

  Color getColor(int index, int timeframesLenght) {
    double step = 0.2;
    int delta = (swiperController.index - index).abs();
    int half = timeframesLenght ~/ 2;
    if (delta.abs() > half) {
      delta = timeframesLenght - delta;
    }
    double opacity = (1 - delta * step);
    return Theme.of(context).primaryColor.withOpacity(opacity);
  }
}

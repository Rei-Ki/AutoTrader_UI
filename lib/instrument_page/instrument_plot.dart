import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:lotosui/instrument_page/instrument_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../bloc/data_classes.dart';

import 'dart:math' as math;

// ignore: must_be_immutable
class Plot extends StatefulWidget {
  const Plot({
    super.key,
    required this.bloc,
    required this.candles,
    required this.swiperController,
  });

  final InstrumentBloc bloc;
  final List<Candle> candles;
  final SwiperController swiperController;

  @override
  State<Plot> createState() => _PlotState();
}

class _PlotState extends State<Plot> {
  late ChartSeriesController chartSeriesController;
  late ZoomPanBehavior zoomPanBehavior;
  late TooltipBehavior tooltipBehavior;
  bool isLegendVisible = false;
  List<String> timeFrames = [
    '1m',
    '5m',
    '15m',
    '30m',
    '1h',
    '2h',
    '4h',
    '1D',
    '1W',
    // '1M' Не работает, видимо косяк в блоке где преобразование в минуты
  ];

  @override
  void initState() {
    zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enableMouseWheelZooming: true,
      enableDoubleTapZooming: true,
      enableSelectionZooming: true,
      enablePanning: true,
    );
    tooltipBehavior = TooltipBehavior(enable: true, duration: 1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          buildTopPanel(),
          // График -------------------------------------------------------------------
          buildChart(context, widget.candles),
          // timeframes ---------------------------------------------------------------
          buildTimeframes(timeFrames)
        ],
      ),
    );
  }

  buildTopPanel() {
    var lastCandle =
        widget.bloc.candles.isNotEmpty ? widget.bloc.candles.last.close : null;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              lastCandle != null ? lastCandle.toStringAsFixed(3) : "Null",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        InkWell(
          onTap: () => setState(() {
            isLegendVisible = !isLegendVisible;
          }),
          child: Container(
            height: 15,
            width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  SfCartesianChart buildChart(BuildContext context, List<Candle> candles) {
    // TODO 3 сделать чтобы Подгружало предыдущие данные как то

    return SfCartesianChart(
      enableAxisAnimation: false,
      zoomPanBehavior: zoomPanBehavior,
      tooltipBehavior: tooltipBehavior,
      primaryXAxis: getPrimaryXAxis(candles, 20),
      primaryYAxis: getPrimaryYAxis(),
      legend: getLegend(),
      margin: const EdgeInsets.only(left: 8, right: 4),
      series: [
        AreaSeries<Candle, dynamic>(
          name: widget.bloc.data.title,
          enableTooltip: true,
          isVisibleInLegend: true,
          borderWidth: 3,
          animationDuration: 0,
          legendIconType: LegendIconType.circle,
          dataSource: candles,
          xValueMapper: (Candle data, _) => data.datetime,
          yValueMapper: (Candle data, _) => data.close,
          borderColor: Theme.of(context).primaryColor.withOpacity(0.7),
          onRendererCreated: (controller) => chartSeriesController = controller,
          markerSettings: markerSettings(context),
          gradient: linearGradient(context),
        )
      ],
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
              onTap: (value) => widget.swiperController.move(value),
              itemCount: timeFrames.length,
              allowImplicitScrolling: true,
              scale: 0.3,
              layout: SwiperLayout.DEFAULT,
              control: const SwiperControl(size: 20), //size: 25
              controller: widget.swiperController,
              onIndexChanged: (value) {
                widget.swiperController.index = value;
                GetIt.I<Talker>().info(
                    "Выбранный таймфрейм: ${timeFrames[value]}, index: $value");
                // Вызов ивента по смене интервала
                context
                    .read<InstrumentBloc>()
                    .add(UpdatePlotDataEvent(timeFrames[value]));
              },
              viewportFraction: 0.15,
              itemBuilder: (context, i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: getColor(i, timeFrames.length),
                  ),
                  child: Center(
                    child: widget.swiperController.index == i
                        ? Text(timeFrames[i].toString(),
                            style: const TextStyle(color: Colors.white))
                        : Text(timeFrames[i].toString(),
                            style: const TextStyle(fontSize: 12)),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Legend getLegend() {
    return Legend(
      // TODO 3 Сделать чтобы легенды хранили трендовые линии чтобы можно было отключать ненужное
      isVisible: isLegendVisible,
      position: LegendPosition.top,
      iconBorderColor: Colors.black,
      alignment: ChartAlignment.center,
      overflowMode: LegendItemOverflowMode.wrap,
    );
  }

  getVisibleMinimum(List<Candle> data, int visibleData) {
    if (data.length - visibleData >= 0) {
      return data[data.length - visibleData].datetime;
    }
    return null;
  }

  MarkerSettings markerSettings(BuildContext context) {
    return MarkerSettings(
      isVisible: true,
      borderColor: Theme.of(context).primaryColor.withOpacity(0.7),
      color: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  getPrimaryXAxis(List<Candle> data, int visibleData) {
    return DateTimeAxis(
      plotOffset: 5,
      initialVisibleMaximum: data.lastOrNull?.datetime,
      initialVisibleMinimum: getVisibleMinimum(data, visibleData),
      dateFormat: DateFormat.Hm(),
      majorGridLines: const MajorGridLines(width: 1),
      labelIntersectAction: AxisLabelIntersectAction.hide,
      edgeLabelPlacement: EdgeLabelPlacement.shift,
      labelPosition: ChartDataLabelPosition.outside,
    );
  }

  getPrimaryYAxis() {
    return const NumericAxis(
      opposedPosition: true,
      axisLine: AxisLine(width: 0),
      enableAutoIntervalOnZooming: true,
      title: AxisTitle(text: ''),
      decimalPlaces: 3,
      labelPosition: ChartDataLabelPosition.outside,
    );
  }

  Color getColor(int index, int timeframesLenght) {
    double step = 0.43;
    int delta = (widget.swiperController.index - index).abs();
    int half = timeframesLenght ~/ 2;
    if (delta.abs() > half) {
      delta = timeframesLenght - delta;
    }
    double opacity = (1 - delta * step);
    opacity = opacity < 0 ? 0 : opacity;
    opacity = opacity > 1 ? 1 : opacity;
    return Theme.of(context).primaryColor.withOpacity(opacity / 1.35);
  }

  LinearGradient linearGradient(BuildContext context) {
    return LinearGradient(
      transform: const GradientRotation(math.pi / 2),
      colors: [
        Theme.of(context).primaryColor.withOpacity(0.5),
        Theme.of(context).primaryColor.withOpacity(0.2),
        Colors.transparent,
      ],
    );
  }
}

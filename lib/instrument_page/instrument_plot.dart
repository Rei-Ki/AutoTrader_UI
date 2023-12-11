import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math' as math;

// ignore: must_be_immutable
class Plot extends StatefulWidget {
  Plot({
    super.key,
    required this.selectedTimeframe,
    required this.timeFrames,
  });

  int selectedTimeframe;
  List<String> timeFrames;
  @override
  State<Plot> createState() => _PlotState();
}

class _PlotState extends State<Plot> {
  late List<LiveData> chartData;
  late ChartSeriesController chartSeriesController;
  late ZoomPanBehavior zoomPanBehavior;
  // int selectedTimeframe = 4;

  @override
  void initState() {
    chartData = getChartData();
    zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enableMouseWheelZooming: true,
      enableDoubleTapZooming: true,
      enableSelectionZooming: true,
      enablePanning: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(width: 35),
              Text(
                chartData.last.speed.toStringAsFixed(2),
                style: const TextStyle(fontSize: 30),
              ),
              Text(widget.timeFrames[widget.selectedTimeframe]),
            ],
          ),
          // График --------------------------------
          SfCartesianChart(
            zoomPanBehavior: zoomPanBehavior,
            margin: const EdgeInsets.only(left: 8, right: 4),
            series: <ChartSeries<LiveData, int>>[
              AreaSeries<LiveData, int>(
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
                dataSource: chartData,
                xValueMapper: (LiveData sales, _) => sales.time,
                yValueMapper: (LiveData sales, _) => sales.speed,
                animationDuration: 800,
                animationDelay: 400,
                markerSettings: MarkerSettings(
                  isVisible: true,
                  borderColor: Theme.of(context).primaryColor.withOpacity(0.7),
                ),
              )
            ],
            primaryXAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 1),
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              interval: 2,
              title: AxisTitle(text: ''),
              decimalPlaces: 0,
              labelPosition: ChartDataLabelPosition.outside,
            ),
            primaryYAxis: NumericAxis(
              opposedPosition: true,
              axisLine: const AxisLine(width: 0),
              enableAutoIntervalOnZooming: true,
              title: AxisTitle(text: ''),
              decimalPlaces: 3,
              labelPosition: ChartDataLabelPosition.outside,
            ),
          ),
          // ---------------------------------------------------------------
          Container(
            margin: const EdgeInsets.all(5),
            height: 25,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: widget.timeFrames.length,
              itemBuilder: (context, index) {
                return TextButton(
                  onPressed: () {
                    widget.selectedTimeframe = index;
                    setState(() {});

                    // todo сделать тут запрос
                    getTime(widget.timeFrames[widget.selectedTimeframe]);
                  },
                  child: Text(widget.timeFrames[index]),
                );
              },
            ),
          )
        ],
      ),
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
    if (timeFrameString.contains("MN")) {
      // todo не совсем уверен в том что месяц именно 30
      return timeFrame * 60 * 24 * 30;
    }
    return 60; // возвращение по стандарту часового интервала
  }

  List<LiveData> getChartData() {
    List<LiveData> data = [];
    for (var i = 0; i < 20; i++) {
      data.add(LiveData(i, math.Random().nextDouble() * 20 + 10));
    }
    return data;
  }

  int getDigitsFromString(String input) {
    RegExp regex = RegExp(r'\d+');
    Iterable<RegExpMatch> matches = regex.allMatches(input);
    return int.parse(matches.map((match) => match.group(0)!).join());
  }
}

class LiveData {
  LiveData(this.time, this.speed);
  final int time;
  final num speed;
}
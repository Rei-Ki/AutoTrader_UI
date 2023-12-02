import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math' as math;

class Plot extends StatefulWidget {
  const Plot({super.key});

  @override
  State<Plot> createState() => _PlotState();
}

class _PlotState extends State<Plot> {
  late List<LiveData> chartData;
  late ChartSeriesController chartSeriesController;
  late ZoomPanBehavior zoomPanBehavior;

  List<String> timeFrames = [
    '1m',
    '5m',
    '15m',
    '30m',
    '60m',
    '2h',
    '4h',
    'D',
    'W',
    'MN'
  ];

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
    // Запрос периодичный
    // Timer.periodic(const Duration(seconds: 1), updateDataSource);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SfCartesianChart(
            zoomPanBehavior: zoomPanBehavior,
            title: ChartTitle(
              text: chartData.last.speed.toStringAsFixed(2),
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
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
              itemCount: timeFrames.length,
              itemBuilder: (context, index) {
                return TextButton(
                  onPressed: () {
                    // todo сделать тут запрос
                  },
                  child: Text(timeFrames[index]),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // Запрос периодичный
  // int time = 19;
  // void updateDataSource(Timer timer) {
  //   chartData.add(LiveData(time++, (math.Random().nextInt(60) + 30)));
  //   chartData.removeAt(0);
  //   _chartSeriesController.updateDataSource(
  //       addedDataIndex: chartData.length - 1, removedDataIndex: 0);
  // }

  List<LiveData> getChartData() {
    List<LiveData> data = [];
    for (var i = 0; i < 20; i++) {
      data.add(LiveData(i, math.Random().nextDouble() * 20 + 10));
    }
    return data;
  }
}

class LiveData {
  LiveData(this.time, this.speed);
  final int time;
  final num speed;
}

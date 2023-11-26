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

  Color plotColor = Colors.pink;

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
      child: SfCartesianChart(
        zoomPanBehavior: zoomPanBehavior,
        title: ChartTitle(
          text: chartData.last.speed.toStringAsFixed(2),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        margin: const EdgeInsets.all(10),
        series: <ChartSeries<LiveData, int>>[
          AreaSeries<LiveData, int>(
            onRendererCreated: (ChartSeriesController controller) {
              chartSeriesController = controller;
            },
            borderWidth: 3,
            borderColor: plotColor,
            gradient: LinearGradient(
              transform: const GradientRotation(math.pi / 2),
              colors: [
                plotColor.withOpacity(0.5),
                plotColor.withOpacity(0.25),
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
              borderColor: plotColor,
            ),
          )
        ],
        primaryXAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 1),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          interval: 2,
          title: AxisTitle(text: ''),
        ),
        primaryYAxis: NumericAxis(
          opposedPosition: true,
          axisLine: const AxisLine(width: 0),
          // enableAutoIntervalOnZooming: true,
          title: AxisTitle(text: ''),
        ),
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

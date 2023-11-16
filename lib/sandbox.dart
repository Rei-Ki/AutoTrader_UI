import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;

  @override
  void initState() {
    chartData = getChartData();
    // Timer.periodic(const Duration(seconds: 1), updateDataSource);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SfCartesianChart(
          margin: const EdgeInsets.all(10),
          series: <LineSeries<LiveData, int>>[
            LineSeries<LiveData, int>(
              onRendererCreated: (ChartSeriesController controller) {
                _chartSeriesController = controller;
              },
              dataSource: chartData,
              color: Colors.indigo,
              xValueMapper: (LiveData sales, _) => sales.time,
              yValueMapper: (LiveData sales, _) => sales.speed,
              animationDuration: 2500,
              animationDelay: 250,
            )
          ],
          primaryXAxis: NumericAxis(
            majorGridLines: const MajorGridLines(width: 1),
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            interval: 1,
            title: AxisTitle(text: 'Время'),
          ),
          primaryYAxis: NumericAxis(
            axisLine: const AxisLine(width: 0),
            // enableAutoIntervalOnZooming: true,
            title: AxisTitle(text: 'Цена'),
          ),
        ),
      ),
    );
  }

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
      data.add(LiveData(i, math.Random().nextInt(50) + 30));
    }
    return data;
  }
}

class LiveData {
  LiveData(this.time, this.speed);
  final int time;
  final num speed;
}

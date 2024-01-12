import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Initialize the data sourcefinal
  List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Jan', y: 4500, secondSeriesYValue: 1000),
    ChartSampleData(x: 'Feb', y: 1000, secondSeriesYValue: 3000),
    ChartSampleData(x: 'March', y: 2500, secondSeriesYValue: 1000),
    ChartSampleData(x: 'April', y: 1000, secondSeriesYValue: 7000),
    ChartSampleData(x: 'May', y: 8500, secondSeriesYValue: 5000),
    ChartSampleData(x: 'June', y: 1400, secondSeriesYValue: 7000)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(numberFormat: NumberFormat.compact()),
        series: <CartesianSeries<ChartSampleData, String>>[
          ColumnSeries<ChartSampleData, String>(
            animationDuration: 3000,
            // Binding the chartData to the dataSource of the column series.
            dataSource: chartData,
            xValueMapper: (ChartSampleData sales, _) => sales.x,
            yValueMapper: (ChartSampleData sales, _) => sales.y,
          ),
          LineSeries<ChartSampleData, String>(
            // Binding the chartData to the dataSource of the line series.
            dataSource: chartData,
            animationDuration: 4000,
            // Set animationDelay to 3000 milliseconds for delay the series rendering.
            animationDelay: 3000,
            xValueMapper: (ChartSampleData sales, _) => sales.x,
            yValueMapper: (ChartSampleData sales, _) =>
                sales.secondSeriesYValue,
          ),
        ],
      )),
    );
  }
}

class ChartSampleData {
  ChartSampleData({this.x, this.y, this.secondSeriesYValue});
  final String? x;
  final num? y;
  final num? secondSeriesYValue;
}

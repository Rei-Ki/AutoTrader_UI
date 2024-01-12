import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  return runApp(_ChartApp());
}

class _ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chart Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  @override
  Widget build(BuildContext context) {
    List<ChartData> chartData = [
      ChartData('2020-09-01', 295),
      ChartData('2020-09-02', 260),
      ChartData('2020-09-03', 278),
      ChartData('2020-09-04', 290),
      ChartData('2020-09-05', 2650),
      ChartData('2020-09-06', 2500),
      ChartData('2020-09-07', 270),
      ChartData('2020-09-08', 263),
      ChartData('2020-09-09', 289),
      ChartData('2020-09-10', 283),
      ChartData('2020-09-11', 240),
      ChartData('2020-09-12', 2655),
      ChartData('2020-09-13', 260),
      ChartData('2020-09-14', 270),
      ChartData('2020-09-15', 280),
      ChartData('2020-09-16', 253),
      ChartData('2020-09-17', 260),
      ChartData('2020-09-18', 280),
      ChartData('2020-09-19', 293),
      ChartData('2020-09-20', 259),
      ChartData('2020-09-21', 270),
      ChartData('2020-09-22', 263),
      ChartData('2020-09-23', 289),
      ChartData('2020-09-24', 283),
      ChartData('2020-09-25', 240),
      ChartData('2020-09-26', 2655),
      ChartData('2020-09-27', 260),
      ChartData('2020-09-28', 270),
      ChartData('2020-09-29', 280),
      ChartData('2020-09-30', 253),
      ChartData('2020-09-31', 2770),
      ChartData('2020-10-01', 280),
      ChartData('2020-10-02', 293),
      ChartData('2020-10-03', 259),
      ChartData('2020-10-03', 300),
      ChartData('2020-10-03', 350),
      ChartData('2020-10-03', 400),
    ];
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: SfCartesianChart(
            backgroundColor: Color(0xCC0A1F32),
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            enableAxisAnimation: true,
            zoomPanBehavior: ZoomPanBehavior(
                // Enables pinch zooming
                enablePanning: true,
                enablePinching: true,
                zoomMode: ZoomMode.x),
            legend: Legend(
                position: LegendPosition.top,
                orientation: LegendItemOrientation.horizontal,
                isVisible: true,
                textStyle: TextStyle(color: Color(0x80C4C6C8), fontSize: 16)),
            palette: const <Color>[Color(0xFF71AF99), Color(0xFFC4BF92)],
            primaryXAxis: CategoryAxis(
                majorGridLines: MajorGridLines(width: 0),
                labelIntersectAction: AxisLabelIntersectAction.hide,
                labelRotation: 320,
                labelAlignment: LabelAlignment.start,
                visibleMinimum: (chartData.length - 15)
                    .toDouble(), // set the visible minimum as the 15 chart data index from the last value.
                visibleMaximum: (chartData.length - 1)
                    .toDouble(), // set the visible minimum as the last value's chart data index.
                maximumLabels: 10),
            primaryYAxis: NumericAxis(
              majorGridLines: MajorGridLines(width: 0),
              labelStyle: TextStyle(color: Color(0xFF71AF99), fontSize: 16),
              minimum: 0,
            ),
            series: <ChartSeries>[
              LineSeries<ChartData, dynamic>(
                  name: "hint",
                  dataSource: chartData,
                  dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.top,
                      builder: (dynamic data, dynamic point, dynamic series,
                          int pointIndex, int seriesIndex) {
                        return Container(
                            child: Text(data.total_price.toString(),
                                style: TextStyle(
                                    color: Color(0xFF71AF99), fontSize: 16)));
                      }),
                  markerSettings: MarkerSettings(
                      isVisible: true, borderWidth: 1, height: 4, width: 4),
                  xValueMapper: (ChartData list, _) => list.service_date,
                  yValueMapper: (ChartData list, _) => list.total_price)
            ]));
  }
}

class ChartData {
  ChartData(this.service_date, this.total_price);

  final String service_date;
  final double total_price;
}

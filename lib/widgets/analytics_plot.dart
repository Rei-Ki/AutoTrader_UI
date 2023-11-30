import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsPlot extends StatefulWidget {
  const AnalyticsPlot({super.key});

  @override
  State<AnalyticsPlot> createState() => _AnalyticsPlotState();
}

class _AnalyticsPlotState extends State<AnalyticsPlot> {
  // todo Показывать на что и как диверсифицированы средства
  late List<Segment> chartData;
  late int total;

  @override
  void initState() {
    chartData = data;
    total = getTotal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SfCircularChart(
        // Сколько на счету
        title: ChartTitle(
          text: total.toString(),
          textStyle: const TextStyle(fontSize: 26),
        ),
        legend: const Legend(
          isVisible: true,
          orientation: LegendItemOrientation.horizontal,
          position: LegendPosition.bottom,
          overflowMode: LegendItemOverflowMode.wrap,
          alignment: ChartAlignment.center,
        ),
        margin: const EdgeInsets.all(0),
        series: <CircularSeries>[
          DoughnutSeries<Segment, String>(
            innerRadius: "60%",
            animationDuration: 400,
            animationDelay: 0,
            dataSource: chartData,
            xValueMapper: (Segment data, _) => data.name,
            yValueMapper: (Segment data, _) => data.value,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.auto,
              labelPosition: ChartDataLabelPosition.outside,
              overflowMode: OverflowMode.shift,
              borderRadius: 25,
              useSeriesColor: true,
            ),
          )
        ],
      ),
    );
  }

  List<Segment> data = [
    Segment(name: "AAPL", value: 1500),
    Segment(name: "GOOGL", value: 2000),
    Segment(name: "MSFT", value: 1200),
    Segment(name: "AMZN", value: 1800),
    Segment(name: "FB", value: 2500),
    Segment(name: "JPM", value: 1600),
    Segment(name: "XOM", value: 3000),
    Segment(name: "Свободные", value: 5000),
  ];

  int getTotal() {
    total = 0;
    for (var i = 0; i < chartData.length; i++) {
      total += chartData[i].value;
    }
    return total;
  }
}

class Segment {
  final String name;
  final int value;

  Segment({required this.name, required this.value});
}

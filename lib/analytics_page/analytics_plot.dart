import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../bloc/data_classes.dart';

// ignore: must_be_immutable
class AnalyticsPlot extends StatefulWidget {
  AnalyticsPlot({
    super.key,
    required this.chartSegments,
  });

  List<Segment> chartSegments;

  @override
  State<AnalyticsPlot> createState() => _AnalyticsPlotState();
}

class _AnalyticsPlotState extends State<AnalyticsPlot> {
  //

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SfCircularChart(
        // Сколько на счету
        title: ChartTitle(
          text: "${getTotal()}",
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
            dataSource: widget.chartSegments,
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

  int getTotal() {
    int total = 0;
    for (var i = 0; i < widget.chartSegments.length; i++) {
      total += widget.chartSegments[i].value;
    }
    return total;
  }
}

/*
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../bloc/data_classes.dart';

// ignore: must_be_immutable
class AnalyticsPlot extends StatefulWidget {
  AnalyticsPlot({
    super.key,
    required this.chartSegments,
  });

  List<Segment> chartSegments;

  @override
  State<AnalyticsPlot> createState() => _AnalyticsPlotState();
}

class _AnalyticsPlotState extends State<AnalyticsPlot> {
  //

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SfCircularChart(
        // Сколько на счету
        title: ChartTitle(
          text: "${getTotal()}",
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
            dataSource: widget.chartSegments,
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

  int getTotal() {
    int total = 0;
    for (var i = 0; i < widget.chartSegments.length; i++) {
      total += widget.chartSegments[i].value;
    }
    return total;
  }
}

 */

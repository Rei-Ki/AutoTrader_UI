import 'package:flutter/material.dart';
import 'package:lotosui/widgets/analytics_plot.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // например: Сделать табы общее, расходы, доходы
        Text("Распределение активов"),

        // График расходов
        AnalyticsPlot(),
      ],
    );
  }
}

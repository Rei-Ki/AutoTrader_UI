import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotosui/analytics_page/analytics_plot.dart';
import 'package:lotosui/bloc/data_classes.dart';

import 'analytics_bloc.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  late BuildContext blocContext;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnalyticsBloc(),
      child: buildAnalyticsBloc(),
    );
  }

  buildAnalyticsBloc() {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
      if (state is AnalyticsInitialState) {
        blocContext = context;
        context.read<AnalyticsBloc>().add(AnalyticsDataLoadEvent());
      }

      if (state is AnalyticsLoadingState) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is AnalyticsLoadedState) {
        List<Segment> segments = state.segments;
        return buildAnalytics(segments);
      }

      if (state is AnalyticsErrorState) {
        return const Center(child: Text("Oops, Something went wrong"));
      }

      return Container();
    });
  }

  Column buildAnalytics(List<Segment> segments) {
    return Column(
      children: [
        // например: Сделать табы общее, расходы, доходы
        const Text("Распределение активов"),
        // График расходов
        AnalyticsPlot(chartSegments: segments),
      ],
    );
  }
}

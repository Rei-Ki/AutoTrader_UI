import 'package:lotosui/view/some/plot.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class LotosInfo extends StatefulWidget {
  const LotosInfo({super.key});

  @override
  State<LotosInfo> createState() => _LotosInfoState();
}

class _LotosInfoState extends State<LotosInfo> {
  String? title;

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    assert(args != null && args is String, "You mast provide String args");

    title = args as String;
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(title ?? '...'),
      ),
      body: title == null
          ? const Center(child: Text('Ой! Нет данных'))
          : const Column(
              children: [
                Plot(),
              ],
            ),
    );
  }
}

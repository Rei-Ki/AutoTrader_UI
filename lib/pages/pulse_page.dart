import 'package:flutter/material.dart';
import 'package:lotosui/widgets/pulse_list.dart';
import 'package:lotosui/widgets/search.dart';

class PulsePage extends StatefulWidget {
  const PulsePage({super.key});

  @override
  State<PulsePage> createState() => _PulsePageState();
}

class _PulsePageState extends State<PulsePage> {
  final TextEditingController searchedPulseText = TextEditingController();
  // todo Сделать фильтрацию по инструментам для пульса

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Search(textController: searchedPulseText),
        const Expanded(
          child: PulseList(),
        )
      ],
    );
  }
}

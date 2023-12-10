import 'package:flutter/material.dart';
import 'package:lotosui/pulse_page/pulse_list.dart';
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
        Search(
          textController: searchedPulseText,
          onChange: (value) {
            print(value);
          },
        ),
        const Expanded(
          child: PulseList(),
        )
      ],
    );
  }
}

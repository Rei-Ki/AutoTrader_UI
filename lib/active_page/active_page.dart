import 'package:flutter/material.dart';
import 'package:lotosui/active_page/active_list.dart';
import 'package:lotosui/widgets/search.dart';

class ActivePage extends StatefulWidget {
  const ActivePage({super.key});

  @override
  State<ActivePage> createState() => _ActivePageState();
}

class _ActivePageState extends State<ActivePage> {
  final TextEditingController searchedInstrumentsText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Search(textController: searchedInstrumentsText),
        ActiveList(filter: searchedInstrumentsText.text),
      ],
    );
  }
}
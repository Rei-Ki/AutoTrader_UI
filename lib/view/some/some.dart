import 'package:flutter/material.dart';

class LotosSome extends StatefulWidget {
  const LotosSome({super.key});

  @override
  State<LotosSome> createState() => _LotosSomeState();
}

class _LotosSomeState extends State<LotosSome> {
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
        title: Text(title ?? '...'),
      ),
    );
  }
}

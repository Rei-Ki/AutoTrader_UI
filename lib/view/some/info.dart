import 'package:flutter/material.dart';

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
  /*
  Сделать чтобы на странице данных можно было добавить в активные и 
  удалять из них

  

  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title ?? '...'),
      ),
    );
  }
}

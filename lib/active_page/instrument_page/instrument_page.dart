import 'package:lotosui/active_page/instrument_page/instrument_plot.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:flutter/material.dart';
// import 'dart:async';

class InstrumentPage extends StatefulWidget {
  const InstrumentPage({super.key});

  @override
  State<InstrumentPage> createState() => _InstrumentPageState();
}

class _InstrumentPageState extends State<InstrumentPage> {
  String? title;
  int _tabTextIndexSelected = 0;

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
          : Column(
              children: [
                const Plot(),
                // ------------------------------------------------------------
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Text("Что то тут еще"),
                      ],
                    ),
                  ),
                ),
                // ------------------------------------------------------------
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlutterToggleTab(
                      width: 70, // width in percent
                      borderRadius: 50,
                      height: 40,
                      selectedIndex: _tabTextIndexSelected,
                      unSelectedBackgroundColors: [
                        Colors.white,
                      ],
                      selectedBackgroundColors: [
                        Theme.of(context).primaryColor.withOpacity(0.7)
                      ],
                      selectedTextStyle:
                          const TextStyle(color: Colors.white, fontSize: 16),
                      unSelectedTextStyle:
                          const TextStyle(color: Colors.black, fontSize: 14),
                      labels: const ["Фрактальная", "Корридорная"],
                      selectedLabelIndex: (index) {
                        setState(() {
                          _tabTextIndexSelected = index;
                          // todo сделать чтобы после старта пропадал этот свитчер
                          print(index);
                        });
                      },
                    ),
                    // ----------------------------------------------------
                    IconButton(
                      onPressed: () {
                        // todo сделать анимацию переключения состояния кнопки
                      },
                      icon: Icon(
                        Icons.play_arrow_outlined,
                        size: 60,
                        color: Theme.of(context).primaryColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                )
              ],
            ),
    );
  }
}

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lotosui/utils/instruments.dart';
import 'package:lotosui/bloc/some_bloc.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final someInstanceBloc = SomeBloc();
  int selectedIndex = 0;

  static const List<Widget> widgetOptions = <Widget>[
    Active(),
    Text('Активное'),
    Text('Пульс'),
    Text('Аналитика'),
  ];

  @override
  void initState() {
    someInstanceBloc.add(LoadSomething());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // ----------------------------------------------------
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      // ----------------------------------------------------
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.transparent,
            )
          ],
        ),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              GNav(
                haptic: false,
                mainAxisAlignment: MainAxisAlignment.center,
                gap: 2,
                iconSize: 24,
                color: Colors.black,
                activeColor: Colors.black,
                tabBackgroundColor: Colors.pink[50]!,
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                tabs: const [
                  GButton(icon: Icons.search, text: 'Активы'),
                  GButton(icon: Icons.add_chart_outlined, text: 'Активное'),
                  GButton(icon: Icons.scatter_plot_outlined, text: 'Пульс'),
                  GButton(icon: Icons.data_usage_rounded, text: 'Аналитика'),
                ],
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                selectedIndex: selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

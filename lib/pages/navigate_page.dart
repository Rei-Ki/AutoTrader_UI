import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:lotosui/pages/active_page.dart';
import 'package:lotosui/pages/pulse_page.dart';

class NavigatePage extends StatefulWidget {
  const NavigatePage({super.key});

  @override
  State<NavigatePage> createState() => _NavigatePageState();
}

class _NavigatePageState extends State<NavigatePage> {
  int selectedIndex = 1;

  static const List<Widget> widgetOptions = <Widget>[
    ActivePage(),
    PulsePage(),
    Text('Аналитика'),
  ];

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

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lotosui/bloc/some_bloc.dart';
import 'package:lotosui/utils/instruments.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class LotosHome extends StatefulWidget {
  const LotosHome({super.key, required this.title});

  final String title;

  @override
  State<LotosHome> createState() => _LotosHomeState();
}

class _LotosHomeState extends State<LotosHome> {
  final _someInstanceBloc = SomeBloc();
  int _selectedIndex = 0;
  int _selectedTheme = 0;

  List themesList = [
    Colors.black,
    Colors.pink,
  ];

  static const List<Widget> _widgetOptions = <Widget>[
    Instruments(),
    Text(
      'Активное',
    ),
    Text(
      'Пульс',
    ),
    Text(
      'Аналитика',
    ),
  ];

  @override
  void initState() {
    _someInstanceBloc.add(LoadSomething());
    super.initState();
  }

//  Сделать градацию черного, темно черного и pink
// сделать еще и отображение общего количества денег и тд
/*
Сделать график обычным а не свечным
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 150, 150, 150),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: SvgPicture.asset(
                'assets/svg/Lotos.svg',
                height: 120,
                colorFilter: ColorFilter.mode(
                    themesList[_selectedTheme], BlendMode.srcIn),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 30,
                  child: ListView.builder(
                      itemCount: themesList.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTheme = i;
                              // Тут сделать обновление всей темы приложения
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: themesList[i],
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
            ListTile(
              title: Text(
                "Настройки",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              leading: Icon(Icons.settings, size: 30),
            )
          ],
        ),
      ),
      // ----------------------------------------------------
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text('Lotos'),
      ),
      // ----------------------------------------------------
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
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
                  fontSize: 18,
                ),
                tabs: const [
                  GButton(icon: Icons.search, text: 'Активы'),
                  GButton(icon: Icons.add_chart_outlined, text: 'Активное'),
                  GButton(icon: Icons.scatter_plot_outlined, text: 'Пульс'),
                  GButton(icon: Icons.data_usage_rounded, text: 'Аналитика'),
                ],
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
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

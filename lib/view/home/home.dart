import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lotosui/bloc/some_bloc.dart';
import 'package:lotosui/variables.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class LotosHome extends StatefulWidget {
  const LotosHome({super.key, required this.title});

  final String title;

  @override
  State<LotosHome> createState() => _LotosHomeState();
}

class _LotosHomeState extends State<LotosHome> {
  final _someInstanceBloc = SomeBloc();
  final instrumentsInfo = instruments;
  int _selectedIndex = 1;
  static const List<Widget> _widgetOptions = <Widget>[
    InstrumentTileWidget(
      instrumentName: "Название инструмента",
    ),
    Text(
      'Главная',
    ),
    Text(
      'Графики',
    ),
  ];

  @override
  void initState() {
    _someInstanceBloc.add(LoadSomething());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 10,
        centerTitle: true,
        surfaceTintColor: Colors.black12,
        backgroundColor: Colors.black12,
        leading: IconButton(
          onPressed: () {},
          icon: SvgPicture.asset('assets/svg/Lotos.svg', height: 30),
        ),
        title: const Text('Lotos'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 3),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              activeColor: Colors.black,
              gap: 8,
              iconSize: 25,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: const [
                GButton(icon: Icons.search, text: 'Поиск'),
                GButton(icon: Icons.all_inclusive_rounded, text: 'Главная'),
                GButton(icon: Icons.scatter_plot_outlined, text: 'Графики'),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

class InstrumentTileWidget extends StatelessWidget {
  const InstrumentTileWidget({
    super.key,
    required this.instrumentName,
  });

  final String instrumentName;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.data_usage_rounded, size: 30),
      title: Text(
        instrumentName,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Text(
        "Тип: Фьючерс",
        style: Theme.of(context).textTheme.labelSmall,
      ),
      onTap: () {
        Navigator.of(context).pushNamed(
          '/some',
          arguments: instrumentName,
        );
      },
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:lotosui/active_page/active_page.dart';
import 'package:lotosui/analytics_page/analytics_page.dart';
// import 'package:lotosui/profile_page/profile_page.dart';
import 'package:lotosui/pulse_page/pulse_page.dart';
import 'package:lotosui/repository.dart';

import 'bloc/main_bloc.dart';

class NavigatePage extends StatefulWidget {
  const NavigatePage({super.key});

  @override
  State<NavigatePage> createState() => _NavigatePageState();
}

class _NavigatePageState extends State<NavigatePage> {
  int selectedIndex = 0;
  List<String> appBarTitles = [
    'Активы',
    // 'Инструмент',
    'Пульс',
    'Аналитика',
  ];

  static const List<Widget> pages = <Widget>[
    ActivePage(),
    // InstrumentPage(),
    PulsePage(),
    AnalyticsPage(),
    // ProfilePage(),
  ];

  // todo сделать смену темы, задника, смену названия AppBar navigate_page

  @override
  Widget build(BuildContext context) {
    return buildMainBloc();
  }

  buildMainBloc() {
    return BlocBuilder<MainBloc, MainState>(builder: (context, state) {
      if (state is MainInitialState) {
        if (!GetIt.I.isRegistered<WebSocketsRepository>()) {
          GetIt.I.registerLazySingleton<WebSocketsRepository>(
            () => WebSocketsRepository("ws://localhost:8765"));
        }

        return buildMainPage(context, appBarTitles[selectedIndex]);
      }

      if (state is MainAppBarUpdatedState) {
        return buildMainPage(context, state.title);
      }

      if (state is MainErrorState) {
        return const Center(child: Text("Oops, Something went wrong (Navigate)"));
      }

      return Container();
    });
  }

  // todo сделать вот тут выбранный инструмент как вкладку

  Scaffold buildMainPage(BuildContext context, String appBar) {
    return Scaffold(
      body: pages.elementAt(selectedIndex),
      // ----------------------------------------------------
      appBar: buildAppBar(appBar),
      // ----------------------------------------------------
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            boxShadow: [BoxShadow(blurRadius: 20, color: Colors.transparent)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GNav(
                haptic: false,
                mainAxisAlignment: MainAxisAlignment.center,
                gap: 3,
                iconSize: 24,
                tabBackgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.1),
                textStyle: const TextStyle(
                  fontSize: 14,
                ),
                tabs: [
                  GButton(icon: Icons.search, text: appBarTitles[0]),
                  // GButton(
                  //     icon: Icons.analytics_outlined, text: appBarTitles[1]),
                  GButton(
                      icon: Icons.scatter_plot_outlined, text: appBarTitles[1]),
                  GButton(
                      icon: Icons.data_usage_rounded, text: appBarTitles[2]),
                ],
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                selectedIndex: selectedIndex,
                onTabChange: (index) {
                  selectedIndex = index;
                  context.read<MainBloc>().add(
                      MainSetAppBarTitleEvent(appBarTitles[selectedIndex]));
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(String appBar) {
    bool isDark = false;
    // todo сделать переключение тем
    return AppBar(
      title: Text(appBar),
      actions: [
        IconButton(
          isSelected: isDark,
          onPressed: () {
            isDark = !isDark;
            setState(() {});
          },
          icon: const Icon(Icons.wb_sunny_outlined),
          selectedIcon: const Icon(Icons.dark_mode_outlined),
        ),
        const SizedBox(width: 5),
      ],
    );
  }
}

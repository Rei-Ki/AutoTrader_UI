import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lotosui/active_page/active_page.dart';
import 'package:lotosui/analytics_page/analytics_page.dart';
import 'package:lotosui/pulse_page/pulse_page.dart';
import 'package:lotosui/repository.dart';
import 'bloc/control_bloc.dart';
import 'bloc/main_bloc.dart';
import 'settings_page/settings_page.dart';

class NavigatePage extends StatefulWidget {
  const NavigatePage({super.key});

  @override
  State<NavigatePage> createState() => _NavigatePageState();
}

class _NavigatePageState extends State<NavigatePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return buildMainBloc();
  }

  buildMainBloc() {
    return BlocBuilder<MainBloc, MainState>(builder: (context, state) {
      if (state is MainInitialState) {
        if (!GetIt.I.isRegistered<ControlBloc>()) {
          ControlBloc controlBloc = context.read<ControlBloc>();
          GetIt.I.registerSingleton<ControlBloc>(controlBloc);
        }
        if (!GetIt.I.isRegistered<WSRepository>()) {
          GetIt.I.registerLazySingleton<WSRepository>(() => WSRepository());
        }

        return buildMainPage(context, PagesEnum.values[selectedIndex].title);
      }

      if (state is MainAppBarUpdatedState) {
        return buildMainPage(context, state.title);
      }

      if (state is MainErrorState) {
        return Center(
            child: Text(
          "Oops, Something went wrong (Navigate)",
          style: Theme.of(context).textTheme.bodySmall,
        ));
      }

      return Container();
    });
  }

  Scaffold buildMainPage(BuildContext context, String appBar) {
    return Scaffold(
      appBar: buildAppBar(PagesEnum.values[selectedIndex].title),
      // ----------------------------------------------------
      body: LiquidPullToRefresh(
        color: Colors.transparent,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
        onRefresh: () => reRegistrateWebsockets(),
        showChildOpacityTransition: false,
        animSpeedFactor: 2.5,
        springAnimationDurationInMilliseconds: 350,
        child: PagesEnum.values[selectedIndex].page,
      ),
      // ----------------------------------------------------
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [navigateBar(context)],
          ),
        ),
      ),
    );
  }

  Future<void> reRegistrateWebsockets() async {
    await GetIt.I<WSRepository>().reconnect();
  }

  Widget navigateBar(BuildContext context) {
    return GNav(
      haptic: false,
      mainAxisAlignment: MainAxisAlignment.center,
      gap: 3,
      iconSize: 24,
      tabBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      textStyle: const TextStyle(
        fontSize: 14,
      ),
      tabs: [
        ...PagesEnum.values
            .mapIndexed((i, e) => GButton(text: e.title, icon: e.icon)),
      ],
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      selectedIndex: selectedIndex,
      onTabChange: (index) {
        selectedIndex = index;
        context.read<MainBloc>().add(
            MainSetAppBarTitleEvent(PagesEnum.values[selectedIndex].title));
        setState(() {});
      },
    );
  }

  buildAppBar(String appBar) {
    var isDark = context.watch<ControlBloc>().isDark;

    return AppBar(
      title: Text(appBar),
      actions: [
        IconButton(
          isSelected: isDark,
          onPressed: () {
            context.read<ControlBloc>().add(ChangeThemeEvent());
          },
          icon: const Icon(Icons.wb_sunny_outlined),
          selectedIcon: const Icon(Icons.dark_mode_outlined),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed("/talkerScreen");
          },
          icon: const Icon(Icons.bookmark_border_rounded),
        ),
        const SizedBox(width: 5),
      ],
    );
  }
}

// TODO сделать как то вкладку\отображение активных (запущенных) чтобы слайдом их убирать

enum PagesEnum {
  active(
    title: 'Активы',
    icon: Icons.search,
    page: ActivePage(),
  ),

  pulse(
    title: 'Пульс',
    icon: Icons.scatter_plot_outlined,
    page: PulsePage(),
  ),
  analytics(
    title: 'Аналитика',
    icon: Icons.data_usage_rounded,
    page: AnalyticsPage(),
  ),
  settings(
    title: 'Настройки',
    icon: Icons.settings_suggest,
    page: SettingsPage(),
  );

  final String title;
  final IconData icon;
  final Widget page;

  const PagesEnum({
    required this.title,
    required this.icon,
    required this.page,
  });
}

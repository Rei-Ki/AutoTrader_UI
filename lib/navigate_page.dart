import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:lotosui/active_page/active_page.dart';
import 'package:lotosui/analytics_page/analytics_page.dart';
import 'package:lotosui/pulse_page/pulse_page.dart';
import 'package:lotosui/repository.dart';
import 'bloc/control_bloc.dart';
import 'bloc/main_bloc.dart';

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
        if (!GetIt.I.isRegistered<WSRepository>()) {
          GetIt.I.registerLazySingleton<WSRepository>(
              () => WSRepository("ws://localhost:8765"));
        }

        return buildMainPage(context, PagesEnum.values[selectedIndex].title);
      }

      if (state is MainAppBarUpdatedState) {
        return buildMainPage(context, state.title);
      }

      if (state is MainErrorState) {
        return const Center(
            child: Text("Oops, Something went wrong (Navigate)"));
      }

      return Container();
    });
  }

  // todo попровать может сделать вот тут выбранный инструмент как вкладку (может упростит код)

  Scaffold buildMainPage(BuildContext context, String appBar) {
    return Scaffold(
      body: PagesEnum.values[selectedIndex].page,
      // ----------------------------------------------------
      appBar: buildAppBar(PagesEnum.values[selectedIndex].title),
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
              navigateBar(context),
            ],
          ),
        ),
      ),
    );
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

// todo сделать как то вкладку\отображение активных (запущенных) чтобы слайдом их убирать

enum PagesEnum {
  active(
    title: 'Активы',
    icon: Icons.search,
    page: ActivePage(),
  ),

  // instrument(
  //   title: 'Активы',
  //   icon: Icons.analytics_outlined,
  //   page: InstrumentPage(),
  // ),

  pulse(
    title: 'Пульс',
    icon: Icons.scatter_plot_outlined,
    page: PulsePage(),
  ),
  analytics(
    title: 'Аналитика',
    icon: Icons.data_usage_rounded,
    page: AnalyticsPage(),
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

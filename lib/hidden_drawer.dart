import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:lotosui/navigate_page.dart';
import 'package:lotosui/profile_page/settings_page.dart';
import 'package:lotosui/style.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> pages = [];
  // todo сделать чтобы имя Главная заменялось на другие (зависит от окна на котором находишься)

  @override
  void initState() {
    super.initState();
    pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Главная',
          baseStyle: mainTextStyle,
          selectedStyle: mainTextStyle,
        ),
        const NavigatePage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Настройки',
          baseStyle: mainTextStyle,
          selectedStyle: mainTextStyle,
        ),
        const SettingsPage(),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Theme.of(context).primaryColor.withOpacity(0.16),
      screens: pages,
      initPositionSelected: 0,
      elevationAppBar: 0,
      isTitleCentered: true,
      backgroundColorAppBar: Colors.transparent,
      isDraggable: true,
      slidePercent: 50,
      verticalScalePercent: 80,
      withShadow: false,
    );
  }
}

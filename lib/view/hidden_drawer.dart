import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:lotosui/style.dart';
import 'package:lotosui/pages/navigate_page.dart';
import 'package:lotosui/view/settings/settings_page.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> pages = [];

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
      backgroundColorMenu: Colors.pink[50]!,
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

import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:lotosui/view/home/home.dart';

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
          baseStyle: TextStyle(),
          selectedStyle: TextStyle(),
        ),
        Home(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Colors.black12,
      screens: pages,
      initPositionSelected: 0,
      elevationAppBar: 0,
      isTitleCentered: true,
      backgroundColorAppBar: Colors.transparent,
      isDraggable: true,
      // ------------------
      // slidePercent: 10,
      // verticalScalePercent: 20,
      withShadow: false,
    );
  }
}

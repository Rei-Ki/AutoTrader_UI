import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

final navBar = Container(
  color: Colors.white,
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
    child: GNav(
      tabActiveBorder: Border.all(color: Colors.black),
      gap: 5,
      color: const Color.fromARGB(255, 0, 0, 0),
      activeColor: Colors.black,
      iconSize: 30,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      // textSize: 10,
      tabs: const [
        GButton(
          icon: Icons.search,
          text: 'Search',
        ),
        GButton(
          icon: Icons.all_inclusive_rounded,
          text: 'Home',
        ),
        GButton(
          icon: Icons.scatter_plot_outlined,
          text: 'Графики',
        ),
      ],
    ),
  ),
);

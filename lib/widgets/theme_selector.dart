import 'package:flutter/material.dart';

class ThemeSelector extends StatefulWidget {
  const ThemeSelector({
    super.key,
  });

  @override
  State<ThemeSelector> createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          // todo сделать список горизонтальным
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  height: 20,
                  width: 20,
                  color: Colors.red[index * 100],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

/*
class _ThemeSelectorState extends State<ThemeSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          // todo сделать список горизонтальным
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  height: 20,
                  width: 20,
                  color: Colors.red[index * 100],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

 */

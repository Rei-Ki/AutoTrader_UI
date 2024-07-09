import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyIconButton extends StatelessWidget {
  MyIconButton({
    super.key,
    required this.iconData,
    required this.text,
    required this.callback,
  });

  final IconData iconData;
  final String text;
  final Function() callback;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: callback,
          icon: Icon(iconData),
        ),
        Text(text),
      ],
    );
  }
}

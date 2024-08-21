import 'package:flutter/material.dart';

class SettingsInput extends StatelessWidget {
  SettingsInput({
    super.key,
    required this.hint,
    required this.controller,
    required this.callback,
    required this.suffix,
    this.icon = const Icon(Icons.edit_rounded),
  });
  final String hint;
  final TextEditingController controller;
  final Function callback;
  final Widget? suffix;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: myBoxDecoration(context),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          alignLabelWithHint: true,
          isCollapsed: true,
          border: InputBorder.none,
          hintText: hint,
          floatingLabelAlignment: FloatingLabelAlignment.center,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: suffix,
          icon: icon,
        ),
        controller: controller,
        onFieldSubmitted: (message) => callback(message),
      ),
    );
  }
}

BoxDecoration myBoxDecoration(
  BuildContext context, {
  double width = 1.5,
  double borderRadius = 15,
}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: Theme.of(context).colorScheme.primary,
      width: width,
    ),
  );
}

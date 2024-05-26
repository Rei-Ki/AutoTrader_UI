import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotosui/bloc/control_bloc.dart';

Widget customSwitchWidget(BuildContext context, callback) {
  return CustomSwitch(
    value: context.read<ControlBloc>().isIpUse,
    callback: callback,
  );
}

class CustomSwitch extends StatelessWidget {
  CustomSwitch({
    super.key,
    this.size = 25,
    required this.value,
    required this.callback,
  });

  bool value;
  final double size;
  final Function(bool) callback;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      isSelected: value,
      onPressed: () => callback(value),
      icon: Icon(Icons.check_rounded, size: size),
      selectedIcon: Icon(Icons.close_rounded, size: size),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lotosui/bloc/control_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // TODO добавить поиск по настройкам
  late TextEditingController controllerIP;

  @override
  void initState() {
    super.initState();

    String uri = GetIt.I<ControlBloc>().wsIp;
    controllerIP = TextEditingController(text: uri);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
      child: Column(
        children: [
          Switch(
            value: context.read<ControlBloc>().isIpUse,
            onChanged: (value) {
              GetIt.I<ControlBloc>().isIpUse = value;
              setState(() {});
              GetIt.I<Talker>().info(
                  "Использование введенного канала соккетов: ${GetIt.I<ControlBloc>().isIpUse}");
            },
          ),
          TextField(
            controller: controllerIP,
            onSubmitted: (message) {
              GetIt.I<ControlBloc>().wsIp = message;
              GetIt.I<Talker>().info(
                  "Текущий канал соккетов: ${GetIt.I<ControlBloc>().wsIp}\nДля применения перезагрузите приложение");
            },
          )
        ],
      ),
    );
  }
}

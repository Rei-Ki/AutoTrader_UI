import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:lotosui/bloc/control_bloc.dart';
import 'package:lotosui/repository.dart';
import 'package:lotosui/widgets/custom_switch.dart';
import 'package:lotosui/widgets/snackbar_tile.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../widgets/settings_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController controllerIP;
  final FToast ftoast = FToast();

  @override
  void initState() {
    super.initState();

    ftoast.init(context);
    String uri = GetIt.I<ControlBloc>().wsIp;
    controllerIP = TextEditingController(text: uri);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Column(
        children: [
          const SizedBox(height: 8),
          fastSettings(context),
          const SizedBox(height: 8),
          settingsInputTile(
            context,
            hint: "Доп. канал соккетов",
            controller: controllerIP,
            callback: onWebSocketSubmitted,
            suffix: customSwitchWidget(context, reRegistration),
            icon: const Icon(Icons.edit_rounded),
          ),
        ],
      ),
    );
  }

  onWebSocketSubmitted(message) {
    GetIt.I<ControlBloc>().wsIp = message;
    GetIt.I<Talker>()
        .info("Текущий канал соккетов: ${GetIt.I<ControlBloc>().wsIp}");
  }

  fastSettings(BuildContext context) {
    var isDark = context.watch<ControlBloc>().isDark;

    return Container(
      // decoration: myBoxDecoration(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              reRegistrateWebsockets();
              showToast(context, ftoast: ftoast, text: "Обновление соединения");
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
          IconButton(
            isSelected: isDark,
            onPressed: () =>
                context.read<ControlBloc>().add(ChangeThemeEvent()),
            icon: const Icon(Icons.wb_sunny_outlined),
            selectedIcon: const Icon(Icons.dark_mode_outlined),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed("/talkerScreen"),
            icon: const Icon(Icons.bookmark_border_rounded),
          ),
        ],
      ),
    );
  }

  reRegistration(bool value) {
    GetIt.I<ControlBloc>().isIpUse = !GetIt.I<ControlBloc>().isIpUse;
    setState(() {});
    String message =
        "Использование введенного канала: ${GetIt.I<ControlBloc>().isIpUse}";
    GetIt.I<Talker>().info(message);

    reRegistrateWebsockets();
    showToast(context, ftoast: ftoast, text: message);
  }
}

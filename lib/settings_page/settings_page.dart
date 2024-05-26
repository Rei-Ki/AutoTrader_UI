import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:lotosui/bloc/control_bloc.dart';
import 'package:lotosui/repository.dart';
import 'package:lotosui/widgets/custom_switch.dart';
import 'package:lotosui/widgets/snackbar_tile.dart';
import 'package:talker_flutter/talker_flutter.dart';

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
          settingsTileWebsockets(context),
        ],
      ),
    );
  }

  Widget settingsTileWebsockets(BuildContext context) {
    // NOTE Отличное поле, нужно его вынести в отдельный виджет
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: settingsBoxDecoration(context),
      child: textFormField(),
    );
  }

  Widget textFormField() {
    return TextFormField(
      inputFormatters: [],
      textAlignVertical: TextAlignVertical.center,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        border: InputBorder.none,
        hintText: "Доп. канал соккетов",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isCollapsed: true,
        icon: const Icon(Icons.edit_rounded),
        suffixIcon: customSwitchWidget(context, reRegistration),
        floatingLabelAlignment: FloatingLabelAlignment.center,
      ),
      controller: controllerIP,
      onFieldSubmitted: (message) {
        GetIt.I<ControlBloc>().wsIp = message;
        GetIt.I<Talker>()
            .info("Текущий канал соккетов: ${GetIt.I<ControlBloc>().wsIp}");
      },
    );
  }

  BoxDecoration settingsBoxDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: Theme.of(context).colorScheme.primary,
        width: 1.5,
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
    showToast(
      context,
      ftoast: ftoast,
      text: message,
    );
  }
}

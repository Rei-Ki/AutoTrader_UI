import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:lotosui/widgets/theme_selector.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final socket = WebSocketChannel.connect(
    Uri.parse('ws://192.168.0.3:8765'),
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: socket.stream,
      builder: (context, snapshot) {
        return Column(
          children: [
            AvatarGlow(
              endRadius: 80,
              animate: true,
              duration: const Duration(milliseconds: 5000),
              glowColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.account_circle_outlined, size: 100),
            ),
            // ----------------------------------------------------------------
            const ThemeSelector(),
            // ----------------------------------------------------------------
            TextFormField(
              onFieldSubmitted: (value) {
                if (value.isNotEmpty) {
                  Map<String, dynamic> data = {
                    "data": value,
                    "cmd": "echo",
                  };
                  socket.sink.add(jsonEncode(data));
                }
              },
            ),

            // ----------------------------------------------------------------
            Text(
                snapshot.hasData ? '${jsonDecode(snapshot.data)["data"]}' : ''),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    socket.sink.close();
    super.dispose();
  }
}

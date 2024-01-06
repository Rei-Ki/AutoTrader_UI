import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WSRepository {
  late WebSocketChannel channel;

  WSRepository(String url) {
    try {
      channel = WebSocketChannel.connect(
        Uri.parse(url),
      );
    } catch (error) {
      debugPrint("WS error: $error");
    }
  }

  Stream<dynamic> get stream => channel.stream;

  void send(Map<String, dynamic> message) {
    debugPrint("Отправка сообщения на сервер: $message");
    channel.sink.add(jsonEncode(message));
  }

  void close() {
    debugPrint("Закрытие канала вебсоккетов");
    channel.sink.close();
  }
}

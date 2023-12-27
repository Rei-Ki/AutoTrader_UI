import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketsRepository {
  late WebSocketChannel channel;

  WebSocketsRepository(String url) {
    try {
      channel = WebSocketChannel.connect(
        Uri.parse(url),
      );
    } catch (error) {
      print("WS error: ${error}");
    }
  }

  Stream<dynamic> get stream => channel.stream;

  void send(Map<String, dynamic> message) {
    debugPrint("Отправка сообщения на сервер: $message");
    channel.sink.add(jsonEncode(message));
  }

  void close() {
    channel.sink.close();
  }
}

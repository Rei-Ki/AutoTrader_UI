import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WSRepository {
  late WebSocketChannel channel;

  // Добавляем контроллер для управления потоками событий
  final _controller = StreamController<dynamic>.broadcast();

  // Публичный поток для подписки на события
  Stream<dynamic> get stream => _controller.stream;

  WSRepository(String url) {
    try {
      channel = WebSocketChannel.connect(
        Uri.parse(url),
      );

      channel.stream.listen((dynamic message) {
        GetIt.I<Talker>().info("Получено сообщение от сервера: $message");
        _controller.add(message);
      });
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
    }
  }

  void send(Map<String, dynamic> message) {
    GetIt.I<Talker>().info("Отправка сообщения на сервер: $message");
    channel.sink.add(jsonEncode(message));
  }

  // Метод для добавления подписчика на события
  void subscribe(Function(dynamic) onData) {
    _controller.stream.listen(onData);
  }

  // Метод для закрытия канала вебсоккетов
  void close() {
    GetIt.I<Talker>().info("Закрытие канала вебсоккетов");
    _controller.close();
    channel.sink.close();
  }
}

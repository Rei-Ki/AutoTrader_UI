import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:lotosui/bloc/control_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WSRepository {
  late WebSocketChannel channel;
  final _controller = StreamController<dynamic>.broadcast();
  StreamSubscription? _channelSubscription;

  Stream<dynamic> get stream => _controller.stream;

  WSRepository() {
    _initializeChannel();
  }

  Future<void> _initializeChannel() async {
    try {
      String? actualIp = await getActualIp();
      if (actualIp != null) {
        channel = WebSocketChannel.connect(
          Uri.parse("ws://$actualIp"),
        );

        _channelSubscription = channel.stream.listen(
          (dynamic message) {
            GetIt.I<Talker>().info("Получено сообщение от сервера:\n$message");
            _controller.add(message);
          },
          onError: (error) =>
              GetIt.I<Talker>().error("Произошла ошибка: $error"),
        );
      } else {
        GetIt.I<Talker>()
            .error("Не удалось получить actualIp для подключения к WebSocket.");
      }
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<String?> getActualIp() async {
    // смотрим использовать IP из настроек или из бд
    bool isIpUse = GetIt.I<ControlBloc>().isIpUse;

    if (isIpUse == true) {
      // IP из введенного в настройках поля
      String actualIp = GetIt.I<ControlBloc>().wsIp;
      GetIt.I<Talker>().info("Подключение к каналу websockets: $actualIp");
      return actualIp;
    }

    // Запрос к бд и обработка данных
    return await extractIpFromDataBase();
  }

  Future<String?> extractIpFromDataBase() async {
    try {
      // Запрос к бд
      FirebaseFirestore db = FirebaseFirestore.instance;

      DocumentSnapshot documentSnapshot =
          await db.doc("settings/websockets").get();
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?;

      String? route = data?['route'];

      // Окончательный выбор канала из бд или при его отсутствии из введенного поля
      String actualIp = route ?? GetIt.I<ControlBloc>().wsIp;
      GetIt.I<Talker>().info(
          "Попытка использования канала websockets: $actualIp\nПри ошибке будет использован канал из настроек");
      return actualIp;
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st,
          "Нет данных в websockets документе.\nИспользуется канал из настроек");
      // при ошибке возвращаем канал в настройках
      return GetIt.I<ControlBloc>().wsIp;
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

  void pause() {
    GetIt.I<Talker>().info("Приостановка канала вебсоккетов");
    _channelSubscription?.pause();
  }

  void resume() {
    GetIt.I<Talker>().info("Возобновление канала вебсоккетов");
    _channelSubscription?.resume();
  }

  Future<void> reconnect() async {
    GetIt.I<Talker>().info("Переподключение к каналу вебсоккетов");
    _channelSubscription?.cancel();
    await channel.sink.close();
    await _initializeChannel();
  }

  // Метод для закрытия канала вебсоккетов
  void close() {
    GetIt.I<Talker>().info("Закрытие канала вебсоккетов");
    channel.sink.close();
    _channelSubscription?.cancel();
    _controller.close();
  }
}

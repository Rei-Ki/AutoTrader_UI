import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketsRepository {
  late WebSocketChannel channel;

  WebSocketsRepository(String url) {
    channel = WebSocketChannel.connect(
      Uri.parse(url),
    );
  }

  Stream<dynamic> get stream => channel.stream;

  void send(Map<String, dynamic> message) {
    channel.sink.add(jsonEncode(message));
  }

  void close() {
    channel.sink.close();
  }
}

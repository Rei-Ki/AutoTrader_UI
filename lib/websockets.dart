import 'dart:convert';
import 'package:lotosui/repository.dart';

main() {
  Map<String, dynamic> json = {
    "data": "Привет",
    "cmd": "echo",
  };

  WSRepository ws = WSRepository("ws://localhost:8765");
  ws.send(json);

  ws.stream.listen((message) {
    // channel.sink.close(status.goingAway);
    print("Recieved ${jsonDecode(message)}");
  });
}

import 'package:web_socket_channel/status.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocket {
  late WebSocketChannel s;
  WebSocketChannel connect() {
    s = WebSocketChannel.connect(
      Uri.parse('ws://quizy-232642f57fa5.herokuapp.com/api/v1'),
    );

    // s.sink.add('Hello');
    return s;
  }

  Stream<dynamic> getMessageStream() {
    return s.stream;
  }

  void printMessage() {
    s.stream.listen((message) {
      print(message);
    });
  }

  sendMessage(String message) {
    s.sink.add(message);
  }

  void closeConnection() {
    s.sink.close();
  }
}

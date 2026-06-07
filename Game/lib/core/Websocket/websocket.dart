import 'package:web_socket_channel/web_socket_channel.dart';

const _wsBaseUrl = 'ws://quizy-232642f57fa5.herokuapp.com/api/v1';

class WebSocket {
  late WebSocketChannel s;
  WebSocketChannel connect() {
    s = WebSocketChannel.connect(Uri.parse(_wsBaseUrl));

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

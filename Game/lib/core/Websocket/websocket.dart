/// Wrapper around [WebSocketChannel] for real-time communication with the backend.
import 'package:web_socket_channel/web_socket_channel.dart';

const _wsBaseUrl = 'wss://quizgame-cr1w.onrender.com/api/v1';

class WebSocket {
  late WebSocketChannel s;

  void connect() {
    s = WebSocketChannel.connect(Uri.parse(_wsBaseUrl));
  }

  Stream<dynamic> getMessageStream() {
    return s.stream;
  }

  void sendMessage(String message) {
    s.sink.add(message);
  }

  void closeConnection() {
    s.sink.close();
  }
}

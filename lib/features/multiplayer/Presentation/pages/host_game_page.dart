import 'dart:math';

import 'package:flutter/material.dart';
import 'package:footy/features/multiplayer/Presentation/pages/waiting_lobby_room_page.dart';

class HostGameWidget extends StatelessWidget {
  const HostGameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final streamController = StreamController();
    // WebSocketChannel channel = connect();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final Random rnd = Random.secure();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    final code = getRandomString(5);
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("game Code is $code"),
          ElevatedButton(
              onPressed: () {
                //  channel = connect();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          // WaitingLobbyPage(name: 'Host', code: code)
                          buildBody(context, name: 'Host', code: code)),
                );
              },
              child: Text('Create Lobby')),
          // StreamBuilder(
          //   stream: channel.stream,
          //   builder: (context, snapshot) {
          //     print('data is ${snapshot.data.toString()}');
          //     return Text(
          //         snapshot.hasData ? '${snapshot.data.toString()}' : '');
          //   },
          // ),
          // ElevatedButton(
          //     onPressed: () {
          //       channel.sink.close();
          //     },
          //     child: Text('close channel')),
        ],
      ),
    ));
  }
}

// WebSocketChannel connect() {
//   final channel = WebSocketChannel.connect(
//     Uri.parse('ws://127.0.0.1:2000/api/v1'),
//   );

//   channel.sink.add('Hello');
//   return channel;
// }

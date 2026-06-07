import 'package:flutter/material.dart';
import 'package:footy/features/multiplayer/Presentation/pages/player_waiting_lobby_page.dart';

class JoinGame extends StatelessWidget {
  const JoinGame({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    late String gamecode;
    return Scaffold(
        body: Center(
            child: Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 60,
            width: 80,
            child: TextFormField(
              decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                  ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                gamecode = value;
                return null;
              },
            ),
          ),
          SizedBox(
              child: ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          // WaitingLobbyPage(name: 'Host', code: code)
                          buildPlayerLobby(context,
                              name: 'User', code: gamecode)),
                );
              }
            },
            child: Text('Join Game'),
          ))
        ],
      ),
    )));
  }
}

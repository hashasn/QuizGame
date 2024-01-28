import 'dart:convert';
import 'dart:math';

import 'package:footy/features/multiplayer/data/MOdels/waiting_lobby_users_model.dart';
import 'package:http/http.dart' as http;

const uri = 'http://192.168.0.4:2000/api/v1';

class AddUsers {
  final String code;
  final String name;
  final String userName;
  final WaitingLobbyUser user;

  AddUsers({required this.name, required this.code, required this.userName})
      : user = WaitingLobbyUser(users: [userName], lobbyCode: code);

  void addUsers() async {
    final client = http.Client();

    await client.post(
      Uri.parse('$uri/waitinglobby'),
      body: json.encode(user.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<String> addNewUser() async {
    final client = http.Client();

    final res = await client.get(
      Uri.parse('$uri/waitinglobby?lobbyCode=$code'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if ((json.decode(res.body)['data']['lobby']).isNotEmpty) {
      Map<String, dynamic> lobby = json.decode(res.body)['data']['lobby'][0];
      print(lobby.toString());
      String id = lobby["_id"];

      client.post(
        Uri.parse('$uri/waitinglobby/$id'),
        body: json.encode({'users': userName}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      return 'exists';
    } else {
      return 'empty';
    }
  }

  void deleteUser() async {
    final client = http.Client();

    final res = await client.get(
      Uri.parse('$uri/waitinglobby?lobbyCode=$code'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    Map<String, dynamic> lobby = json.decode(res.body)['data']['lobby'][0];

    String id = lobby["_id"];
    // String username = user.users.toString();

    client.delete(
      Uri.parse('$uri/waitinglobby/deleteOneUser/$id'),
      body: json.encode({'users': userName}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  void deleteAllUsers() async {
    final client = http.Client();
    final res = await client.get(
      Uri.parse('$uri/waitinglobby?lobbyCode=$code'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    Map<String, dynamic> lobby = json.decode(res.body)['data']['lobby'][0];

    String id = lobby["_id"];

    client.delete(
      Uri.parse('$uri/waitinglobby/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<String> getId() async {
    final client = http.Client();
    final res = await client.get(
      Uri.parse('$uri/waitinglobby?lobbyCode=$code'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    Map<String, dynamic> lobby = json.decode(res.body)['data']['lobby'][0];
    //print(lobby.toString());
    String id = lobby["_id"];
    return id;
  }
}

int randomNum() {
  var rng = Random();

  return rng.nextInt(100);
}

import 'dart:convert';
import 'dart:math';

import 'package:footy/features/multiplayer/data/MOdels/waiting_lobby_users_model.dart';
import 'package:http/http.dart' as http;

const uri = 'https://quizy-232642f57fa5.herokuapp.com/api/v1';

class AddUsers {
  final http.Client client;

  AddUsers({required this.client});
  void addUsers(String userName, String code) async {
    WaitingLobbyUser lobby =
        WaitingLobbyUser(users: [userName], lobbyCode: code);

    await client.post(
      Uri.parse('$uri/waitinglobby'),
      body: json.encode(lobby.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<String> addNewUser(String code, String userName) async {
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

  void deleteUser(String gameCode, String userName) async {
    final res = await client.get(
      Uri.parse('$uri/waitinglobby?lobbyCode=$gameCode'),
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

  void deleteAllUsers(String lobbyCode) async {
    final res = await client.get(
      Uri.parse('$uri/waitinglobby?lobbyCode=$lobbyCode'),
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

  Future<String> getId(String code) async {
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

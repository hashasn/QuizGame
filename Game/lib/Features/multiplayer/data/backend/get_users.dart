/// Fetches the current waiting lobby from the API using the lobby ID stored in SharedPreferences.
import 'dart:convert';

import 'package:footy/features/multiplayer/data/MOdels/waiting_lobby_users_model.dart';
import 'package:footy/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const uri = 'https://quizgame-cr1w.onrender.com/api/v1';

class GetUsers {
  final http.Client client;

  GetUsers({required this.client});
  Future<WaitingLobbyUser> getLobby() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('lobbyID');

    final res = await client.get(
      Uri.parse('$uri/waitinglobby/$id'),
    );

    if (res.statusCode == 200) {
      final data = res.body;
      //print('data is $data');
      final Map<String, dynamic> decodedData = jsonDecode(data);
      //print('decoded data is $decodedData');
      final Map<String, dynamic> lobbyData = decodedData["data"]["lobby"];
      //  print('lobby data is $lobbyData');
      return WaitingLobbyUser.fromJson(lobbyData);
    } else {
      throw ServerException();
    }
  }
}

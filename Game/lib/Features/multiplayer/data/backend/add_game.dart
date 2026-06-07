import 'dart:convert';

import 'package:footy/features/multiplayer/data/MOdels/game_model.dart';
import 'package:http/http.dart' as http;

const uri = 'https://quizgame-cr1w.onrender.com/api/v1';

class CreateGame {
  final http.Client client;

  CreateGame({required this.client});

  void AddGame(String code, String quizId, List<User> players, int time) async {
    GameModel newGame =
        GameModel(gameCode: code, quiz: quizId, users: players, time: time);

    await client.post(
      Uri.parse('$uri/game'),
      body: jsonEncode(newGame.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
}

import 'dart:convert';

import 'package:footy/features/multiplayer/data/MOdels/game_model.dart';
import 'package:http/http.dart' as http;

const uri = 'http://127.0.0.1:2000/api/v1';

class CreateGame {
  final String gameCode;
  final String quizId;
  final List<User> players;
  final GameModel newGame;
  final int time;

  CreateGame(
      {required this.quizId,
      required this.players,
      required this.gameCode,
      required this.time})
      : newGame = GameModel(
            users: players, quiz: quizId, gameCode: gameCode, time: time);

  void AddGame() async {
    final client = http.Client();

    await client.post(
      Uri.parse('$uri/game'),
      body: jsonEncode(newGame.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
}

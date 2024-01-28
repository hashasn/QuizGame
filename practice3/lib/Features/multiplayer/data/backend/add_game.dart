import 'dart:convert';

import 'package:footy/features/multiplayer/data/MOdels/game_model.dart';
import 'package:http/http.dart' as http;

const uri = 'http://192.168.0.4:2000/api/v1';

class CreateGame {
  final String gameCode;
  final String quizId;
  final List<User> players;
  final GameModel newGame;

  CreateGame(
      {required this.quizId, required this.players, required this.gameCode})
      : newGame = GameModel(users: players, quiz: quizId, gameCode: gameCode);

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

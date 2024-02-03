import 'dart:convert';

import 'package:footy/core/error/exceptions.dart';
import 'package:footy/features/Quizzes/Data/models/model_quizzes.dart';
import 'package:footy/features/multiplayer/data/MOdels/game_model.dart';
import 'package:http/http.dart' as http;

const uri = 'http://127.0.0.1:2000/api/v1';

class FetchGameData {
  final http.Client client;

  FetchGameData({required this.client});

  Future<QuizeModel> getGame(String gameCode) async {
    print('game code is $gameCode');
    final client = http.Client();
    final res = await client.get(
      Uri.parse('$uri/game?gameCode=$gameCode'),
    );

    if (res.statusCode == 200) {
      final data = res.body;
      //print('data is $data');
      final Map<String, dynamic> decodedData = jsonDecode(data);
      //print('decoded data is $decodedData');
      print('fONeeee${decodedData["data"]["finalGame"]['quiz']}');

      final Map<String, dynamic> gameData =
          decodedData["data"]["finalGame"]["quiz"];
      //  print('lobby data is $lobbyData');
      return QuizeModel.fromJson(gameData);
    } else {
      throw ServerException();
    }
  }

  Future<List<User>> getGameData(String gameCode) async {
    List<User> user = [];
    final client = http.Client();
    final res = await client.get(
      Uri.parse('$uri/game?gameCode=$gameCode'),
    );
    if (res.statusCode == 200) {
      final data = res.body;
      //print('data is $data');
      final Map<String, dynamic> decodedData = jsonDecode(data);
      // print('decoded data is $decodedData');
      // print('fONeeee${decodedData["data"]["game"]["quiz"]}');

      final Map<String, dynamic> gameData = decodedData["data"]["finalGame"];
      print('lobby data is ${gameData['users'].length}');
      for (int i = 0; i < gameData['users'].length; i++) {
        user.add(User.fromJson(gameData['users'][i]));
      }
      return user;
    } else {
      throw ServerException();
    }
  }

  void updateScore(String code, String name, String score, bool isComplete) {
    final client = http.Client();

    User newUser = User(name: name, score: score, complete: isComplete);
    client.patch(
      Uri.parse('$uri/game?gameCode=$code'),
      body: json.encode(newUser.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<int> getTime(String code) async {
    final client = http.Client();
    final res = await client.get(
      Uri.parse('$uri/game?gameCode=$code'),
    );
    if (res.statusCode == 200) {
      final data = res.body;
      //print('data is $data');
      final Map<String, dynamic> decodedData = jsonDecode(data);
      // print('decoded data is $decodedData');
      // print('fONeeee${decodedData["data"]["game"]["quiz"]}');

      final Map<String, dynamic> gameData = decodedData["data"]["finalGame"];
      int time = gameData['time'];
      return time;
    } else {
      throw ServerException();
    }
  }

  void deleteGameColl(String gameCode) {
    final client = http.Client();
    client.delete(Uri.parse('$uri/game?gameCode=$gameCode'));
  }
}

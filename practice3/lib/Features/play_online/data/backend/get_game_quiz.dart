import 'dart:convert';

import 'package:footy/core/error/exceptions.dart';
import 'package:footy/features/Quizzes/Data/models/model_quizzes.dart';
import 'package:http/http.dart' as http;

const uri = 'http://192.168.0.4:2000/api/v1';

class FetchQuizForOnline {
  final http.Client client;

  FetchQuizForOnline({required this.client});

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
      // print('fONeeee${decodedData["data"]["game"]["quiz"]}');

      final Map<String, dynamic> gameData =
          decodedData["data"]["game"][0]["quiz"];
      //  print('lobby data is $lobbyData');
      return QuizeModel.fromJson(gameData);
    } else {
      throw ServerException();
    }
  }
}

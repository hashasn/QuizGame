import 'dart:convert';

import 'package:footy/core/error/exceptions.dart';
import 'package:footy/features/Quizzes/Data/models/model_quizzes.dart';
import 'package:http/http.dart' as http;

const uri = 'https://quizy-232642f57fa5.herokuapp.com/api/v1';

class GetRemoteQuizzesMultiplaer {
  final http.Client client;

  GetRemoteQuizzesMultiplaer({required this.client});

  // static const token =
  //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1OGQwMDIwODExNmY4NzJmNGQ0MmZhMSIsImlhdCI6MTcwMzczOTQyNCwiZXhwIjoxNzExNTE1NDI0fQ.MEQxzvUfo1U0FSZkXX-Ihuoi_Hdm1OzyilYgpMiqdFw';

  Future<QuizzesModel> getQuizzes() async {
    final response = await client.get(
      Uri.parse('$uri/quizes'),
    );

    //print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return QuizzesModel.fromJson(data);
    } else {
      throw ServerException();
    }
  }
}

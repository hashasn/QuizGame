import 'dart:convert';

import 'package:footy/Features/Quizzes/Data/models/model_quizzes.dart';
import 'package:footy/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

abstract class QuizzesRemoteDataSource {
  /// Throws a [ServerException] for all error codes.

  Future<QuizzesModel> getQuizzes();
}

const uri = 'http://127.0.0.1:2000/api/v1';

@singleton
class QuizzesRemoteDataSourceImpl implements QuizzesRemoteDataSource {
  final http.Client client;
  QuizzesRemoteDataSourceImpl({required this.client});

  // static const token =
  //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1OGQwMDIwODExNmY4NzJmNGQ0MmZhMSIsImlhdCI6MTcwMzczOTQyNCwiZXhwIjoxNzExNTE1NDI0fQ.MEQxzvUfo1U0FSZkXX-Ihuoi_Hdm1OzyilYgpMiqdFw';
  @override
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

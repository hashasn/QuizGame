/// Reads and writes the quiz catalogue to SharedPreferences as a JSON string for offline use.
import 'dart:convert';

import 'package:footy/features/Quizzes/Data/models/model_quizzes.dart';
import 'package:footy/core/error/exceptions.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class QuizzesLocalDataSource {
  Future<QuizzesModel> getLastQuiz();

  Future<void> cacheQuiz(QuizzesModel quizToCache);
}

const cachedQuiz = 'Cached_Quizz';

@singleton
class QuizzesLocalDataSourceImpl extends QuizzesLocalDataSource {
  final SharedPreferences sharedPreferences;

  QuizzesLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<QuizzesModel> getLastQuiz() {
    final jsonString = sharedPreferences.getString(cachedQuiz);

    if (jsonString != null) {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      return Future.value(QuizzesModel.fromJson(data));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheQuiz(QuizzesModel quizToCache) {
    return sharedPreferences.setString(
        cachedQuiz, json.encode(quizToCache.toJson())); //
  }
}

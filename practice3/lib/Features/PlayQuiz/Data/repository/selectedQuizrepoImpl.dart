import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:footy/features/PlayQuiz/Business/repository/selectedQuizrepo.dart';
import 'package:footy/features/PlayQuiz/Data/DataSource/localSelectedQuiz.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/features/Quizzes/Data/DataSources/quizzes_local_data_source.dart';
import 'package:footy/core/error/failure.dart';

class SelectedQuizRepoImpl implements SelectedQuizRepo {
  final QuizzesLocalDataSource localDataSource;

  SelectedQuizRepoImpl({required this.localDataSource});
  @override
  Future<Either<Failure, Quize>> getQuiz() async {
    final quiz = selectedQuizzes.elementAt(0);

    return Right(quiz);
  }
}

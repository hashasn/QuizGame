import 'package:dartz/dartz.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';

import '../../../../core/error/failure.dart';

abstract class QuizzesMultiplayerRepository {
  Future<Either<Failure, Quizzes>> getMultiplayerQuizzes();
}

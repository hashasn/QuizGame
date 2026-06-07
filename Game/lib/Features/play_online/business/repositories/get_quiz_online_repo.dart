import 'package:dartz/dartz.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';

abstract class OnlinePlayQuizRepo {
  Future<Either<Failure, Quize>> getOnlinePlayQuiz(String code);
}

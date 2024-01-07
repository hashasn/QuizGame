import 'package:dartz/dartz.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/Features/Quizzes/Business/Entities/quizzes.dart';

abstract class QuizzesRepository {
  Future<Either<Failure, Quizzes>> getQuizzes();
}

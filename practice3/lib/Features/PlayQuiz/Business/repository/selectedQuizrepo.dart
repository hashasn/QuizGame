import 'package:dartz/dartz.dart';
import 'package:footy/Features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/core/error/failure.dart';

abstract class SelectedQuizRepo {
  Future<Either<Failure, Quize>> getQuiz();
}

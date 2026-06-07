/// Use case that fetches the full quiz catalogue from the repository.
import 'package:dartz/dartz.dart';

import 'package:footy/core/error/failure.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/features/Quizzes/Business/Repositories/quizzes_repository.dart';

class GetQuizzes {
  final QuizzesRepository repository;
  GetQuizzes({required this.repository});

  Future<Either<Failure, Quizzes>> call() {
    return repository.getQuizzes();
  }
}

import 'package:dartz/dartz.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/features/multiplayer/business/repository/quizzes_repo.dart';

class GetQuizzesForMultiplayer {
  final QuizzesMultiplayerRepository repository;

  GetQuizzesForMultiplayer({required this.repository});

  Future<Either<Failure, Quizzes>> call() {
    return repository.getMultiplayerQuizzes();
  }
}

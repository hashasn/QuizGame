import 'package:dartz/dartz.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/features/play_online/business/repositories/get_quiz_online_repo.dart';

class OnlinePlayQuiz {
  final OnlinePlayQuizRepo repository;

  OnlinePlayQuiz({required this.repository});

  Future<Either<Failure, Quize>> call(String code) {
    return repository.getOnlinePlayQuiz(code);
  }
}

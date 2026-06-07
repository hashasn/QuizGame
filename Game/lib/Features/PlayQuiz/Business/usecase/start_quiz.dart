import 'package:dartz/dartz.dart';
import 'package:footy/features/PlayQuiz/Business/repository/selectedQuizrepo.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/core/error/failure.dart';

class startQuiz {
  final SelectedQuizRepo repo;
  startQuiz({required this.repo});

  Future<Either<Failure, Quize>> call() {
    return repo.getQuiz();
  }
}

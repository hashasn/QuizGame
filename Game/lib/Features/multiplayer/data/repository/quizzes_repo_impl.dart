import 'package:dartz/dartz.dart';
import 'package:footy/core/error/exceptions.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/features/multiplayer/business/repository/quizzes_repo.dart';
import 'package:footy/features/multiplayer/data/backend/get_quizzes.dart';

class QuizzesMultiplayerRepositoryImpl implements QuizzesMultiplayerRepository {
  final GetRemoteQuizzesMultiplaer remote;

  QuizzesMultiplayerRepositoryImpl({required this.remote});
  @override
  Future<Either<Failure, Quizzes>> getMultiplayerQuizzes() async {
    try {
      final quizzes = await remote.getQuizzes();

      return Right(quizzes);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

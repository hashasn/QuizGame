import 'package:dartz/dartz.dart';
import 'package:footy/core/error/exceptions.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/features/play_online/business/repositories/get_quiz_online_repo.dart';
import 'package:footy/features/play_online/data/backend/game_data.dart';

class OnlinePlayQuizRepoImpl implements OnlinePlayQuizRepo {
  final FetchGameData data;

  OnlinePlayQuizRepoImpl({required this.data});

  @override
  Future<Either<Failure, Quize>> getOnlinePlayQuiz(String code) async {
    try {
      final gameQuiz = await data.getGame(code);

      return Right(gameQuiz);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

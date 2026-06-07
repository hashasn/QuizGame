import 'package:dartz/dartz.dart';
import 'package:footy/core/error/exceptions.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/multiplayer/data/MOdels/game_model.dart';
import 'package:footy/features/play_online/business/repositories/get_score_repo.dart';
import 'package:footy/features/play_online/data/backend/game_data.dart';

class GetScoreRepoImpl implements GetScoreRepo {
  final FetchGameData data;

  GetScoreRepoImpl({required this.data});
  @override
  Future<Either<Failure, List<User>>> getScore(String code) async {
    try {
      final game = await data.getGameData(code);
      final userScoreData = game;
      print('users are $userScoreData');

      return Right(userScoreData as List<User>);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

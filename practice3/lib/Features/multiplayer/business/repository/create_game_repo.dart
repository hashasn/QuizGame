import 'package:dartz/dartz.dart';
import 'package:footy/features/multiplayer/data/MOdels/game_model.dart';

import '../../../../core/error/failure.dart';

abstract class CreateGameRespository {
  Future<Either<Failure, void>> createGame(
      String code, String quizId, List<User> players, int time);
}

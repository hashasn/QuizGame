

import 'package:dartz/dartz.dart';
import 'package:footy/core/error/exceptions.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/multiplayer/business/repository/create_game_repo.dart';
import 'package:footy/features/multiplayer/data/MOdels/game_model.dart';
import 'package:footy/features/multiplayer/data/backend/add_game.dart';

class CreateGameRespositoryImpl implements CreateGameRespository {
  final CreateGame game;

  CreateGameRespositoryImpl({required this.game});

  @override
  Future<Either<Failure, void>> createGame(
      String code, String quizId, List<User> players, int time) async {
    try {
      game.AddGame(code, quizId, players, time);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

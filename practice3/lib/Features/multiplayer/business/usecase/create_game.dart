import 'package:dartz/dartz.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/multiplayer/business/repository/create_game_repo.dart';
import 'package:footy/features/multiplayer/data/MOdels/game_model.dart';

class CreateGameUseCase {
  final CreateGameRespository repo;

  CreateGameUseCase({required this.repo});

  Future<Either<Failure, void>> call(
      String code, String quizId, List<User> players, int time) {
    return repo.createGame(code, quizId, players, time);
  }
}

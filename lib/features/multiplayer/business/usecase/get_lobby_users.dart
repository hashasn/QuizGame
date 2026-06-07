import 'package:dartz/dartz.dart';
import 'package:footy/features/multiplayer/business/repository/lobby_repository.dart';
import 'package:footy/features/multiplayer/data/MOdels/waiting_lobby_users_model.dart';
import 'package:footy/core/error/failure.dart';

class GetPlayers {
  final WaitingLobbyRepo repo;

  GetPlayers({required this.repo});

  Future<Either<Failure, WaitingLobbyUser>> call() {
    return repo.getPlayers();
  }
}

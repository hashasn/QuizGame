import 'package:dartz/dartz.dart';
import 'package:footy/features/multiplayer/data/MOdels/waiting_lobby_users_model.dart';
import 'package:footy/core/error/failure.dart';

abstract class WaitingLobbyRepo {
  Future<Either<Failure, WaitingLobbyUser>> getPlayers();
}

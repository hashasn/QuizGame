import 'package:dartz/dartz.dart';
import 'package:footy/features/multiplayer/business/repository/lobby_repository.dart';
import 'package:footy/features/multiplayer/data/MOdels/waiting_lobby_users_model.dart';
import 'package:footy/features/multiplayer/data/backend/get_users.dart';
import 'package:footy/core/error/exceptions.dart';
import 'package:footy/core/error/failure.dart';

class WaitingLobbyRepoImpl implements WaitingLobbyRepo {
  final GetUsers dataSource;

  WaitingLobbyRepoImpl({required this.dataSource});

  @override
  Future<Either<Failure, WaitingLobbyUser>> getPlayers() async {
    try {
      final users = await dataSource.getLobby();

      return Right(users);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

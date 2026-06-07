

import 'package:dartz/dartz.dart';
import 'package:footy/core/error/exceptions.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/multiplayer/business/repository/create_lobby_repo.dart';
import 'package:footy/features/multiplayer/data/backend/add_user.dart';

class CreateLobbyRepositoryImpl implements CreateLobbyRepository {
  final AddUsers remote;

  CreateLobbyRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, void>> createLobby(
      String userName, String code) async {
    try {
      remote.addUsers(userName, code);

      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

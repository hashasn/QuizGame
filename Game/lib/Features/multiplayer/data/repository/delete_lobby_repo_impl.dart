

import 'package:dartz/dartz.dart';
import 'package:footy/core/error/exceptions.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/multiplayer/business/repository/delete_lobby_repo.dart';
import 'package:footy/features/multiplayer/data/backend/add_user.dart';

class DeleteLobbyRepositoryImpl implements DeleteLobbyRepository {
  final AddUsers remote;

  DeleteLobbyRepositoryImpl({required this.remote});
  @override
  Future<Either<Failure, void>> deleteLobby(String code) async {
    try {
      remote.deleteAllUsers(code);

      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:footy/core/error/exceptions.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/play_online/business/repositories/delete_game_repo.dart';
import 'package:footy/features/play_online/data/backend/game_data.dart';

class DeleteGameRepoImpl implements DeleteGameRepo {
  final FetchGameData gameData;

  DeleteGameRepoImpl({required this.gameData});

  @override
  Future<Either<Failure, void>> deleteGame(String code) async {
    try {
      gameData.deleteGameColl(code);
      return Right(Void);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

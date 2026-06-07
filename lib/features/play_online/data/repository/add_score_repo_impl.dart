import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:footy/core/error/exceptions.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/play_online/business/repositories/add_score_repo.dart';
import 'package:footy/features/play_online/data/backend/game_data.dart';

class AddScoreRepoImpl implements AddScoreRepo {
  final FetchGameData data;

  AddScoreRepoImpl({required this.data});

  @override
  Future<Either<Failure, void>> addScore(
      String code, String name, String score, bool isComplete) async {
    try {
      data.updateScore(code, name, score, isComplete);
      return Right(Void);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

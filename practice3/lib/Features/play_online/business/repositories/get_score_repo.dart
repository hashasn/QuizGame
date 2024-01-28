import 'package:dartz/dartz.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/multiplayer/data/MOdels/game_model.dart';

abstract class GetScoreRepo {
  Future<Either<Failure, User>> getScore();
}

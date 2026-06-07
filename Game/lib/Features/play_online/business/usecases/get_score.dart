import 'package:dartz/dartz.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/multiplayer/data/MOdels/game_model.dart';
import 'package:footy/features/play_online/business/repositories/get_score_repo.dart';

class GetScore {
  final GetScoreRepo repository;

  GetScore({required this.repository});

  Future<Either<Failure, List<User>>> call(String code) {
    return repository.getScore(code);
  }
}

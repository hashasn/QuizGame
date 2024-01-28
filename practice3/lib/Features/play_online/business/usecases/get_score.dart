import 'package:dartz/dartz.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/multiplayer/data/MOdels/game_model.dart';
import 'package:footy/features/play_online/business/repositories/get_score_repo.dart';

class getScore {
  final GetScoreRepo repository;

  getScore({required this.repository});

  Future<Either<Failure, User>> call() {
    return repository.getScore();
  }
}

import 'package:dartz/dartz.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/play_online/business/repositories/add_score_repo.dart';

class AddScore {
  final AddScoreRepo repo;

  AddScore({required this.repo});

  Future<Either<Failure, void>> call(
      String code, String name, String score, bool isComplete) {
    return repo.addScore(code, name, score, isComplete);
  }
}

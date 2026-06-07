import 'package:dartz/dartz.dart';
import 'package:footy/core/error/failure.dart';

abstract class AddScoreRepo {
  Future<Either<Failure, void>> addScore(
      String code, String name, String score, bool isComplete);
}

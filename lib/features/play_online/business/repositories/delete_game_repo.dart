import 'package:dartz/dartz.dart';
import 'package:footy/core/error/failure.dart';

abstract class DeleteGameRepo {
  Future<Either<Failure, void>> deleteGame(String code);
}

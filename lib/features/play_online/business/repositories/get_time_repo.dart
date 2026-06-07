import 'package:dartz/dartz.dart';
import 'package:footy/core/error/failure.dart';

abstract class GetTimeRepo {
  Future<Either<Failure, int>> getTime(String code);
}

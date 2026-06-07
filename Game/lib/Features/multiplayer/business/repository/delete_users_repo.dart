import 'package:dartz/dartz.dart';
import 'package:footy/core/error/failure.dart';

abstract class DeleteUserRepository {
  Future<Either<Failure, void>> deleteUser(String code, String userName);
}

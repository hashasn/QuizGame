import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class AddNewUsersRepository {
  Future<Either<Failure, String>> addNewUsers(String code, String userName);
}

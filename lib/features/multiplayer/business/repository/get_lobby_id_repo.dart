import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class GetIdRepository {
  Future<Either<Failure, String>> getId(String code);
}

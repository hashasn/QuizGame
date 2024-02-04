import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class CreateLobbyRepository {
  Future<Either<Failure, void>> createLobby(String userName, String code);
}

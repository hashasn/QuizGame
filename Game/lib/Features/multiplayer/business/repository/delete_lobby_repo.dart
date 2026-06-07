import 'package:dartz/dartz.dart';
import 'package:footy/core/error/failure.dart';

abstract class DeleteLobbyRepository {
  Future<Either<Failure, void>> deleteLobby(String code);
}

import 'package:dartz/dartz.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/multiplayer/business/repository/get_lobby_id_repo.dart';

class GetId {
  final GetIdRepository repo;

  GetId({required this.repo});

  Future<Either<Failure, String>> call(String code) {
    return repo.getId(code);
  }
}

import 'package:dartz/dartz.dart';
import 'package:footy/core/error/exceptions.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/multiplayer/business/repository/get_lobby_id_repo.dart';
import 'package:footy/features/multiplayer/data/backend/add_user.dart';

class GetIdRepositoryImpl implements GetIdRepository {
  final AddUsers remote;

  GetIdRepositoryImpl({required this.remote});
  @override
  Future<Either<Failure, String>> getId(String code) async {
    try {
      final data = await remote.getId(code);

      return Right(data);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

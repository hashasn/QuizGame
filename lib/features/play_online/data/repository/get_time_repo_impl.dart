import 'package:dartz/dartz.dart';
import 'package:footy/core/error/exceptions.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/play_online/business/repositories/get_time_repo.dart';
import 'package:footy/features/play_online/data/backend/game_data.dart';

class GetTimeRepoImpl implements GetTimeRepo {
  final FetchGameData data;

  GetTimeRepoImpl({required this.data});
  @override
  Future<Either<Failure, int>> getTime(String code) async {
    try {
      final time = await data.getTime(code);

      return Right(time);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

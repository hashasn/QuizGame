import 'package:dartz/dartz.dart';
import 'package:footy/Features/Quizzes/Business/Repositories/quizzes_repository.dart';
import 'package:footy/core/error/exceptions.dart';

import 'package:footy/core/error/failure.dart';
import 'package:footy/Features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/Features/Quizzes/Data/DataSources/quizzes_local_data_source.dart';
import 'package:footy/Features/Quizzes/Data/DataSources/quizzes_remote_data_source.dart';

import 'package:footy/core/network/network_info.dart';
import 'package:injectable/injectable.dart';

@singleton
class QuizzesRepositoryImpl implements QuizzesRepository {
  final QuizzesRemoteDataSource remoteDataSource;
  final QuizzesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  QuizzesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Quizzes>> getQuizzes() async {
    if (await networkInfo.isConnected) {
      try {
        final quizzes = await remoteDataSource.getQuizzes();
        localDataSource.cacheQuiz(quizzes);
        return Right(quizzes);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localQuiz = await localDataSource.getLastQuiz();
        return Right(localQuiz);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}

import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:footy/core/error/exceptions.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/multiplayer/business/repository/delete_users_repo.dart';
import 'package:footy/features/multiplayer/data/backend/add_user.dart';

class DeleteUserRepositoryImpl implements DeleteUserRepository {
  final AddUsers remote;

  DeleteUserRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, void>> deleteUser(String code, String userName) async {
    try {
      remote.deleteUser(code, userName);
      return Right(Void);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:footy/core/error/exceptions.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/multiplayer/business/repository/add_users_lobby_repo.dart';
import 'package:footy/features/multiplayer/data/backend/add_user.dart';

class AddNewUsersRepositoryImpl implements AddNewUsersRepository {
  final AddUsers remote;

  AddNewUsersRepositoryImpl({required this.remote});
  @override
  Future<Either<Failure, String>> addNewUsers(
      String code, String userName) async {
    try {
      final data = await remote.addNewUser(code, userName);

      return Right(data);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

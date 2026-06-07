import 'package:dartz/dartz.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/multiplayer/business/repository/add_users_lobby_repo.dart';

class AddNewUsers {
  final AddNewUsersRepository repo;

  AddNewUsers({required this.repo});

  Future<Either<Failure, String>> call(String code, String userName) {
    return repo.addNewUsers(code, userName);
  }
}

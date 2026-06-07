import 'package:dartz/dartz.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/multiplayer/business/repository/delete_users_repo.dart';

class DeleteUser {
  final DeleteUserRepository repo;

  DeleteUser({required this.repo});

  Future<Either<Failure, void>> call(String code, String userName) {
    return repo.deleteUser(code, userName);
  }
}

import 'package:dartz/dartz.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/multiplayer/business/repository/create_lobby_repo.dart';

class CreateLobby {
  final CreateLobbyRepository repo;

  CreateLobby({required this.repo});

  Future<Either<Failure, void>> call(String userName, String code) {
    return repo.createLobby(userName, code);
  }
}

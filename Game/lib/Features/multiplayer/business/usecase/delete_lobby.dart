import 'package:dartz/dartz.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/multiplayer/business/repository/delete_lobby_repo.dart';

class DeleteLobby {
  final DeleteLobbyRepository repo;

  DeleteLobby({required this.repo});

  Future<Either<Failure, void>> call(String code) {
    return repo.deleteLobby(code);
  }
}

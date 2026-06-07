import 'package:dartz/dartz.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/play_online/business/repositories/delete_game_repo.dart';

class DeleteGame {
  final DeleteGameRepo repo;

  DeleteGame({required this.repo});

  Future<Either<Failure, void>> call(String code) {
    return repo.deleteGame(code);
  }
}

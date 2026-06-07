import 'package:dartz/dartz.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/play_online/business/repositories/get_time_repo.dart';

class GetTime {
  final GetTimeRepo repository;

  GetTime({required this.repository});

  Future<Either<Failure, int>> call(String code) {
    return repository.getTime(code);
  }
}

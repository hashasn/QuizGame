import 'package:footy/Features/Quizzes/Data/DataSources/quizzes_local_data_source.dart';
import 'package:footy/Features/Quizzes/Data/DataSources/quizzes_remote_data_source.dart';

import 'package:footy/core/network/network_info.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements QuizzesRemoteDataSource {}

class MockLocalDataSource extends Mock implements QuizzesLocalDataSource {}

class MockNetwotkInfo extends Mock implements NetworkInfo {}

void main() {
  // late QuizzesRepositoryImpl repository;
  // late MockRemoteDataSource mockRemoteDataSource;
  // late MockLocalDataSource mockLocalDataSource;
  // late MockNetwotkInfo mockNetwotkInfo;

  // setUp(() {
  //   mockLocalDataSource = MockLocalDataSource();
  //   mockRemoteDataSource = MockRemoteDataSource();
  //   mockNetwotkInfo = MockNetwotkInfo();
  //   repository = QuizzesRepositoryImpl(
  //     remoteDataSource: mockRemoteDataSource,
  //     localDataSource: mockLocalDataSource,
  //     networkInfo: mockNetwotkInfo,
  //   );
  // });

  // group('getWuizzes', () {
  //   test('check if device is online', () {
  //     //arrange
  //     // when(() => mockNetwotkInfo.isConnected).thenAnswer((_) async => true);
  //     //act
  //     repository.getQuizzes();
  //     //assert

  //     verify(() => mockNetwotkInfo.isConnected);
  //   });
  // });
}

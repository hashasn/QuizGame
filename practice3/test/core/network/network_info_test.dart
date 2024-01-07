import 'package:flutter_test/flutter_test.dart';
import 'package:footy/core/network/network_info.dart';
import 'package:mocktail/mocktail.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class MockDataConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl =
        NetworkInfoImpl(connectionChecker: mockDataConnectionChecker);
  });

  group('isConnected', () {
    test('should forward the call to INternetConnectionChecker.hasConnection',
        () async {
      //arrange
      //final tHassconnection = Future.value(true);
      when(() => mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);

      //act
      final result = await networkInfoImpl.isConnected;
      //assert
      verify(() => mockDataConnectionChecker.hasConnection);
      expect(result, true);
    });
  });
}

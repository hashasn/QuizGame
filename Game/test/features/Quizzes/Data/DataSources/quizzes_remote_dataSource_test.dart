import 'package:flutter_test/flutter_test.dart';
import 'package:footy/Features/Quizzes/Data/DataSources/quizzes_remote_data_source.dart';
import 'package:footy/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late QuizzesRemoteDataSourceImpl dataSource;

  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = QuizzesRemoteDataSourceImpl(client: mockHttpClient);
    registerFallbackValue(FakeUri());
  });

  group('get quizzes remote', () {
    test('return quiz when status code is 200 success', () async {
      //arrange
      //  const tNumber = '6586bc3211d3f9d858fbef1f';

      //print(fixture('RemoteOneResponse.json'));

      when(() => mockHttpClient.get(any())).thenAnswer(
          (_) async => http.Response(fixture('RemoteOneResponse.json'), 200));

      //act
      dataSource.getQuizzes();
      //assert

      verify(() => mockHttpClient.get(Uri.parse('$uri/quizes')));
    });

    test('shiuld thro w=an exception error when status code is 404 or other ',
        () async {
      //arrange

      when(() => mockHttpClient.get(any()))
          .thenAnswer((_) async => http.Response('something went wrong', 404));

      //act
      final call = dataSource.getQuizzes;
      //assert

      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}

// import 'dart:convert';

// import 'package:flutter_test/flutter_test.dart';
// import 'package:footy/Features/Quizzes/Data/DataSources/quizzes_local_data_source.dart';
// import 'package:footy/Features/Quizzes/Data/models/model_quizzes.dart';
// import 'package:footy/core/error/exceptions.dart';

// import 'package:mocktail/mocktail.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../../../fixtures/fixture_reader.dart';

// class MockSharedPreferences extends Mock implements SharedPreferences {}

// void main() {
//   late QuizzesLocalDataSourceImpl dataSource;
//   late MockSharedPreferences mockSharedPreferences;

//   setUp(() {
//     mockSharedPreferences = MockSharedPreferences();
//     dataSource =
//         QuizzesLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
//   });

//   group('getlastQuiz', () {
//     final tQuizz = QuizzesModel.fromJson(jsonDecode(fixture('quizzes.json')));
//     test(
//         'should return quizz from SharedPreferences when there is one in the cache',
//         () async {
//       //arrange
//       when(() => mockSharedPreferences.getString(any()))
//           .thenReturn(fixture('quizzes.json'));

//       //act
//       final result = await dataSource.getLastQuiz();

//       //assert
//       verify(() => mockSharedPreferences.getString(cachedQuiz));
//       expect(result, tQuizz);
//     });

//     test('should throught cacheException when there is not cached value',
//         () async {
//       //arrange
//       when(() => mockSharedPreferences.getString(cachedQuiz)).thenReturn(null);

//       //act
//       final call = dataSource.getLastQuiz;

//       //assert

//       expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
//     });
//   });

//   group('cacheQuiz', () {
//     final tquizModel = QuizzesModel(
//       title: 'title',
//       image: 'fg',
//       category: 'sdf',
//       questions: List.empty(),
//     );
//     print(tquizModel);
//     test('should call sharedprefs to cache data ', () async {
//       // arrange
//       when(() => mockSharedPreferences.setString(cachedQuiz, any()))
//           .thenAnswer((_) async => true);

//       //act
//       dataSource.cacheQuiz(tquizModel);

//       // assert
//       final expectedJson = json.encode(tquizModel.toJson());
//       print(expectedJson);
//       verify(
//         () => mockSharedPreferences.setString(cachedQuiz, expectedJson),
//       );
//     });
//   });
// }

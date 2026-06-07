// import 'dart:convert';

// import 'package:flutter_test/flutter_test.dart';
// import 'package:footy/Features/Quizzes/Data/models/model_quizzes.dart';
// import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';

// import '../../../../fixtures/fixture_reader.dart';

// void main() {
//   final tQuizModel = QuizzesModel(
//     title: '',
//     category: '',
//     image: '',
//     questions: List.empty(),
//   );

//   test(
//     'should be a sub class of Quizzes entety',
//     () async {
//       //assert
//       expect(tQuizModel, isA<Quizzes>());
//     },
//   );

//   group('fromJson', () {
//     test('should return a valid model', () async {
//       // arrange
//       final Map<String, dynamic> jsonMap = json.decode(fixture('quizzes.json'));

//       // act
//       final result = QuizzesModel.fromJson(jsonMap);

//       //assert
//       expect(result, tQuizModel);
//     });
//   });

//   group('toJson', () {
//     test('should return a json map', () async {
//       //act
//       final result = tQuizModel.toJson();
//       //assert

//       final expectedMap = {
//         "title": "",
//         "image": "",
//         "category": "",
//         "questions": []
//       };

//       expect(result, expectedMap);
//     });
//   });
// }

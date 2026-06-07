// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';

// class MockQuestionsRepository extends Mock implements QuestionsRepository {}

// void main() {
//   late StartQuiz usecase;

//   late MockQuestionsRepository mockQuestionsRepository;

//   setUp(() {
//     mockQuestionsRepository = MockQuestionsRepository();
//     usecase = StartQuiz(repo: mockQuestionsRepository);
//   });
//   List<Questions> questions = [];

//   // final tQuizzes = Quizzes(
//   //   status: '',
//   //   results: 0,
//   //   data: Data(quizes: []),
//   // );
//   test(
//     'should get questions from the repository',
//     () async {
//       when(() => mockQuestionsRepository.getQuestions())
//           .thenAnswer((_) async => Right(questions));

//       final result = await usecase();
//       expect(result, Right(questions));
//       verify(() => mockQuestionsRepository.getQuestions());

//       verifyNoMoreInteractions(mockQuestionsRepository);
//     },
//   );
// }

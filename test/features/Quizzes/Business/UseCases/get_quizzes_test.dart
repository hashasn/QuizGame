import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/features/Quizzes/Business/Repositories/quizzes_repository.dart';
import 'package:footy/features/Quizzes/Business/UseCases/get_quizzes.dart';
import 'package:mocktail/mocktail.dart';

class MockQuizzesRepository extends Mock implements QuizzesRepository {}

void main() {
  late GetQuizzes usecase;

  late MockQuizzesRepository mockQuizzesRepository;

  setUp(() {
    mockQuizzesRepository = MockQuizzesRepository();
    usecase = GetQuizzes(repository: mockQuizzesRepository);
  });
  //List<Question> questions = [];

  final tQuizzes = Quizzes(
    status: '',
    results: 0,
    data: Data(quizes: []),
  );
  test(
    'should get quizzes from the repository',
    () async {
      when(() => mockQuizzesRepository.getQuizzes())
          .thenAnswer((_) async => Right(tQuizzes));

      final result = await usecase();
      expect(result, Right(tQuizzes));
      verify(() => mockQuizzesRepository.getQuizzes());

      verifyNoMoreInteractions(mockQuizzesRepository);
    },
  );
}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/features/Quizzes/Business/UseCases/get_quizzes.dart';
import 'package:footy/features/Quizzes/Presentation/bloc/quizzes_bloc.dart';
import 'package:footy/core/error/failure.dart';
import 'package:mocktail/mocktail.dart';

class MockGetQuizzes extends Mock implements GetQuizzes {}

void main() {
  late MockGetQuizzes mockGetQuizzes;
  late QuizzesBloc bloc;

  final tQuizzes = Quizzes(status: '', results: 0, data: Data(quizes: []));

  setUp(() {
    mockGetQuizzes = MockGetQuizzes();
    bloc = QuizzesBloc(mockGetQuizzes);
  });

  tearDown(() => bloc.close());

  test('emits [LoadingState, SuccessState] on success', () {
    when(() => mockGetQuizzes()).thenAnswer((_) async => Right(tQuizzes));

    expectLater(bloc.stream, emitsInOrder([LoadingState(), SuccessState(qs: tQuizzes)]));

    bloc.add(QuizzesInitialEvent());
  });

  test('emits [LoadingState, ErrorState] on server failure', () {
    when(() => mockGetQuizzes()).thenAnswer((_) async => Left(ServerFailure()));

    expectLater(bloc.stream, emitsInOrder([LoadingState(), const ErrorState(error: 'Server failure')]));

    bloc.add(QuizzesInitialEvent());
  });

  test('emits [LoadingState, ErrorState] on cache failure', () {
    when(() => mockGetQuizzes()).thenAnswer((_) async => Left(CacheFailure()));

    expectLater(bloc.stream, emitsInOrder([LoadingState(), const ErrorState(error: 'Cache failure')]));

    bloc.add(QuizzesInitialEvent());
  });
}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:footy/Features/Quizzes/Business/UseCases/get_quizzes.dart';
import 'package:footy/Features/Quizzes/Presentation/bloc/quizzes_bloc.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/Features/Quizzes/Business/Entities/quizzes.dart';
import 'package:mocktail/mocktail.dart';

class MockGetQuizzes extends Mock implements GetQuizzes {}

void main() {
  late MockGetQuizzes mockGetQuizzes;
  late QuizzesBloc bloc;

  setUp(() {
    mockGetQuizzes = MockGetQuizzes();
    bloc = QuizzesBloc(mockGetQuizzes);
  });

  test('emits LoadingState, SuccessState when QuizzesInitialEvent is added',
      () {
    // Arrange
    final tQuizzes = Quizzes(status: '', results: 0, data: Data(quizes: []));
    when(() => bloc.getQuizzes()).thenAnswer((_) async => Right(tQuizzes));

    // Act and Assert
    expectLater(
      bloc.stream,
      emitsInOrder([
        LoadingState(),
        SuccessState(qs: tQuizzes),
      ]),
    );

    // Act
    bloc.add(QuizzesInitialEvent());
  });

  test('unsuccessfull call', () async {
    //arrange
    when(() => mockGetQuizzes()).thenAnswer((_) async => Left(CacheFailure()));

    // Act
    bloc.add(QuizzesInitialEvent());

    //assert
    expectLater(
        bloc.stream,
        emitsInOrder(
            {LoadingState(), const ErrorState(error: 'Server Failure')}));
  });
}

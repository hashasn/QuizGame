import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/features/multiplayer/data/MOdels/game_model.dart';
import 'package:footy/features/play_online/business/usecases/add_user_score.dart';
import 'package:footy/features/play_online/business/usecases/delete_game.dart';
import 'package:footy/features/play_online/business/usecases/get_quiz_online.dart';
import 'package:footy/features/play_online/business/usecases/get_score.dart';
import 'package:footy/features/play_online/business/usecases/get_time.dart';
import 'package:footy/features/play_online/presentation/bloc/game_bloc.dart';
import 'package:footy/core/Websocket/websocket.dart';
import 'package:footy/core/error/failure.dart';
import 'package:mocktail/mocktail.dart';

class MockOnlinePlayQuiz extends Mock implements OnlinePlayQuiz {}
class MockGetScore extends Mock implements GetScore {}
class MockAddScore extends Mock implements AddScore {}
class MockDeleteGame extends Mock implements DeleteGame {}
class MockGetTime extends Mock implements GetTime {}
class MockWebSocket extends Mock implements WebSocket {}

final tQuiz = Quize(
  id: 'quiz1', title: 'Test', image: '', category: 'test',
  questions: List.generate(3, (i) => Question(prompt: 'Q$i', options: ['A','B','C','D'], answers: 'A')),
);

void main() {
  late MockOnlinePlayQuiz mockGameQuiz;
  late MockGetScore mockGetScore;
  late MockAddScore mockAddScore;
  late MockDeleteGame mockDeleteGame;
  late MockGetTime mockGetTime;
  late MockWebSocket mockSocket;
  late StreamController<dynamic> wsController;
  late GameBloc bloc;

  setUp(() {
    mockGameQuiz = MockOnlinePlayQuiz();
    mockGetScore = MockGetScore();
    mockAddScore = MockAddScore();
    mockDeleteGame = MockDeleteGame();
    mockGetTime = MockGetTime();
    mockSocket = MockWebSocket();
    wsController = StreamController<dynamic>.broadcast();

    when(() => mockSocket.getMessageStream()).thenAnswer((_) => wsController.stream);
    when(() => mockGameQuiz(any())).thenAnswer((_) async => Right(tQuiz));
    when(() => mockGetTime(any())).thenAnswer((_) async => const Right(30));
    when(() => mockAddScore(any(), any(), any(), any())).thenAnswer((_) async => const Right(null));
    when(() => mockDeleteGame(any())).thenAnswer((_) async => const Right(null));
    when(() => mockGetScore(any())).thenAnswer((_) async => Right(<User>[]));

    bloc = GameBloc(mockGameQuiz, mockGetScore, mockAddScore, mockDeleteGame, mockGetTime, mockSocket);
  });

  tearDown(() async {
    await bloc.close();
    await wsController.close();
  });

  test('GameInitialEvent emits [LoadingState, SuccessState] on success', () {
    expectLater(bloc.stream, emitsInOrder([
      isA<GameLoadingState>(),
      isA<GameSuccessState>(),
    ]));

    bloc.add(GameInitialEvent(gameCode: 'game123', username: 'player1'));
  });

  test('GameInitialEvent emits [LoadingState, ErrorState] when quiz fails', () {
    when(() => mockGameQuiz(any())).thenAnswer((_) async => Left(ServerFailure()));

    expectLater(bloc.stream, emitsInOrder([
      isA<GameLoadingState>(),
      isA<GameErrorState>(),
    ]));

    bloc.add(GameInitialEvent(gameCode: 'game123', username: 'player1'));
  });

  test('correct answer emits canAnswer=false then advances count', () async {
    bloc.add(GameInitialEvent(gameCode: 'game123', username: 'player1'));
    await Future.delayed(const Duration(seconds: 4));

    expectLater(bloc.stream, emitsInOrder([
      isA<GameSuccessState>().having((s) => s.canAnswer, 'canAnswer', false),
      isA<GameSuccessState>().having((s) => s.count, 'count', 1),
    ]));

    bloc.add(GameAnswerSelected(isRight: true, index: 0, answerIndex: 0));
  });

  test('wrong answer emits canAnswer=false then advances count', () async {
    bloc.add(GameInitialEvent(gameCode: 'game123', username: 'player1'));
    await Future.delayed(const Duration(seconds: 4));

    expectLater(bloc.stream, emitsInOrder([
      isA<GameSuccessState>().having((s) => s.canAnswer, 'canAnswer', false),
      isA<GameSuccessState>().having((s) => s.count, 'count', 1),
    ]));

    bloc.add(GameAnswerSelected(isRight: false, index: 2, answerIndex: 0));
  });

  test('last question calls addScore with isComplete=true', () async {
    bloc.add(GameInitialEvent(gameCode: 'game123', username: 'player1'));
    await Future.delayed(const Duration(seconds: 4));
    bloc.add(GameAnswerSelected(isRight: true, index: 0, answerIndex: 0)); // q0
    await Future.delayed(const Duration(seconds: 4));
    bloc.add(GameAnswerSelected(isRight: true, index: 0, answerIndex: 0)); // q1
    await Future.delayed(const Duration(seconds: 4));
    bloc.add(GameAnswerSelected(isRight: true, index: 0, answerIndex: 0)); // q2 — last
    await Future.delayed(const Duration(seconds: 4));

    verify(() => mockAddScore(any(), any(), any(), true)).called(1);
    verify(() => mockAddScore(any(), any(), any(), false)).called(2);
  });

  test('BackToLobbyEvent emits [GameLoadingState, BackToLobbyActionState]', () async {
    bloc.add(GameInitialEvent(gameCode: 'game123', username: 'player1'));
    await Future.delayed(const Duration(seconds: 4));

    // GameLoadingState has empty Equatable props, so the second emission is deduplicated
    expectLater(bloc.stream, emitsInOrder([
      isA<GameLoadingState>(),
      isA<BackToLobbyActionState>(),
    ]));

    bloc.add(BackToLobbyEvent());
  });
}

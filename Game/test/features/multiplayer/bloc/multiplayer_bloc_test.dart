import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/features/multiplayer/bloc/multiplayer_lobby_bloc/multiplayer_bloc.dart';
import 'package:footy/features/multiplayer/business/usecase/create_game.dart';
import 'package:footy/features/multiplayer/business/usecase/create_lobby.dart';
import 'package:footy/features/multiplayer/business/usecase/delete_lobby.dart';
import 'package:footy/features/multiplayer/business/usecase/get_lobby_users.dart';
import 'package:footy/features/multiplayer/business/usecase/get_quizzes.dart';
import 'package:footy/features/multiplayer/data/MOdels/waiting_lobby_users_model.dart';
import 'package:footy/core/Websocket/websocket.dart';
import 'package:footy/core/error/failure.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPlayers extends Mock implements GetPlayers {}
class MockGetQuizzesForMultiplayer extends Mock implements GetQuizzesForMultiplayer {}
class MockCreateLobby extends Mock implements CreateLobby {}
class MockDeleteLobby extends Mock implements DeleteLobby {}
class MockCreateGameUseCase extends Mock implements CreateGameUseCase {}
class MockWebSocket extends Mock implements WebSocket {}

void main() {
  late MockGetPlayers mockGetPlayers;
  late MockGetQuizzesForMultiplayer mockGetQuizzes;
  late MockCreateLobby mockCreateLobby;
  late MockDeleteLobby mockDeleteLobby;
  late MockCreateGameUseCase mockCreateGame;
  late MockWebSocket mockSocket;
  late StreamController<dynamic> wsController;
  late MultiplayerBloc bloc;

  final tLobby = WaitingLobbyUser(lobbyCode: 'lobby123', users: ['player1', 'player2']);
  final tQuizzes = Quizzes(status: '', results: 0, data: Data(quizes: []));

  setUp(() {
    mockGetPlayers = MockGetPlayers();
    mockGetQuizzes = MockGetQuizzesForMultiplayer();
    mockCreateLobby = MockCreateLobby();
    mockDeleteLobby = MockDeleteLobby();
    mockCreateGame = MockCreateGameUseCase();
    mockSocket = MockWebSocket();
    wsController = StreamController<dynamic>.broadcast();

    when(() => mockSocket.getMessageStream()).thenAnswer((_) => wsController.stream);
    when(() => mockGetPlayers()).thenAnswer((_) async => Right(tLobby));
    when(() => mockGetQuizzes()).thenAnswer((_) async => Right(tQuizzes));
    when(() => mockCreateLobby(any(), any())).thenAnswer((_) async => const Right(null));
    when(() => mockDeleteLobby(any())).thenAnswer((_) async => const Right(null));
    when(() => mockCreateGame(any(), any(), any(), any())).thenAnswer((_) async => const Right(null));

    bloc = MultiplayerBloc(mockGetPlayers, mockGetQuizzes, mockCreateLobby, mockDeleteLobby, mockCreateGame, mockSocket);
  });

  tearDown(() async {
    await bloc.close();
    await wsController.close();
  });

  test('LobbychangedEvent emits LobbyChangedstate on success', () {
    expectLater(bloc.stream, emitsInOrder([isA<LobbyChangedstate>()]));
    bloc.add(LobbychangedEvent());
  });

  test('LobbychangedEvent emits LobbyErrorState when quiz fetch fails', () {
    when(() => mockGetQuizzes()).thenAnswer((_) async => Left(ServerFailure()));
    expectLater(bloc.stream, emitsInOrder([isA<LobbyErrorState>()]));
    bloc.add(LobbychangedEvent());
  });

  test('LobbychangedEvent emits LobbyErrorState when players fetch fails', () {
    when(() => mockGetPlayers()).thenAnswer((_) async => Left(ServerFailure()));
    expectLater(bloc.stream, emitsInOrder([isA<LobbyErrorState>()]));
    bloc.add(LobbychangedEvent());
  });

  test('StartGameEvent emits StartGameActionState on success', () {
    expectLater(bloc.stream, emitsInOrder([isA<StartGameActionState>()]));
    bloc.add(StartGameEvent(id: 'quiz1', players: tLobby, time: '30'));
  });

  test('StartGameEvent emits LobbyErrorState when createGame fails', () {
    when(() => mockCreateGame(any(), any(), any(), any())).thenAnswer((_) async => Left(ServerFailure()));
    expectLater(bloc.stream, emitsInOrder([isA<LobbyErrorState>()]));
    bloc.add(StartGameEvent(id: 'quiz1', players: tLobby, time: '30'));
  });

  test('LeaveGameEvent emits [LobbyLoadingstate, LeaveGameActionState] on success', () {
    expectLater(bloc.stream, emitsInOrder([isA<LobbyLoadingstate>(), isA<LeaveGameActionState>()]));
    bloc.add(LeaveGameEvent());
  });

  test('LeaveGameEvent emits [LobbyLoadingstate, LobbyErrorState] when deleteLobby fails', () {
    when(() => mockDeleteLobby(any())).thenAnswer((_) async => Left(ServerFailure()));
    expectLater(bloc.stream, emitsInOrder([isA<LobbyLoadingstate>(), isA<LobbyErrorState>()]));
    bloc.add(LeaveGameEvent());
  });
}

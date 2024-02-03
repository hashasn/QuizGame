import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:footy/core/Websocket/websocket.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/features/multiplayer/data/MOdels/game_model.dart';
import 'package:footy/features/play_online/business/usecases/add_user_score.dart';
import 'package:footy/features/play_online/business/usecases/delete_game.dart';
import 'package:footy/features/play_online/business/usecases/get_quiz_online.dart';
import 'package:footy/features/play_online/business/usecases/get_score.dart';
import 'package:footy/features/play_online/business/usecases/get_time.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final WebSocket socket = WebSocket();
  final OnlinePlayQuiz gameQuiz;
  final GetTime getTime;
  final GetScore getScore;
  final AddScore addSCore;
  final DeleteGame deleteGame;
  String gameCode = '';
  String userName = '';
  List<User> users = [];
  int score = 0;
  int quizTime = 0;

  late Either<Failure, Quize> quiz;
  late Either<Failure, int> time;

  int count = 0;
  GameBloc(this.gameQuiz, this.getScore, this.addSCore, this.deleteGame,
      this.getTime)
      : super(GameInitial()) {
    socket.connect();
    socket.sendMessage('game');
    socket.getMessageStream().listen(
      (event) async {
        //  print('Received message: $event');

        if (event != null) {
          if (event is String && event.contains('operationType')) {
            String coll = json.decode(event)['ns']['coll'];
            if (coll == 'gameschemas') {
              String type = json.decode(event)['operationType'];
              if (type == 'update') {
                if (count > 9) {
                  add(GameResultsUpdateEvent());
                }
              }
            }

            // String id = json.decode(event)['documentKey']['_id'];s
            // String lobbyCode = json.decode(event)['documentKey']['lobbyCode'];
          }
        }
      },
    );

    on<GameInitialEvent>(gameInitialEvent);
    // on<GameNextQuestion>(gameNextQuestion);
    on<GameAnswerSelected>(gameAnswerSelected);
    on<GameResultsEvent>(gameResultsEvent);
    on<BackToLobbyEvent>(backToLobbyEvent);
    on<GameResultsUpdateEvent>(gameResultsUpdateEvent);
  }

  FutureOr<void> gameInitialEvent(
      GameInitialEvent event, Emitter<GameState> emit) async {
    List<Color> borderColors = List.generate(4, (index) => Colors.blueGrey);
    emit(GameLoadingState(loadString: 'Starting Game'));
    await Future.delayed(Duration(seconds: 3));

    gameCode = event.gameCode;
    userName = event.username;
    time = await getTime(event.gameCode);
    time.fold((l) => GameErrorState(error: 'Failed to Fetch time'),
        (r) => quizTime = r);
    quiz = await gameQuiz(event.gameCode);
    quiz.fold(
      (left) => emit(GameErrorState(error: 'Failed to Fetxh Quiz')),
      (right) => emit(GameSuccessState(
          users: users,
          qs: right,
          count: count,
          canAnswer: true,
          color: borderColors,
          timerSetting: 'start',
          time: quizTime)),
    );
  }

  // FutureOr<void> gameNextQuestion(
  //     GameNextQuestion event, Emitter<GameState> emit) async {
  //   List<Color> borderColors = List.generate(4, (index) => Colors.blueGrey);
  //   print('i am here in bloc');
  //   count++;

  //   emit(GameNewQuestionState());
  //   await Future.delayed(Duration(seconds: 3));

  //   quiz.fold(
  //     (left) => emit(GameErrorState(error: 'Failed to  change state start')),
  //     (right) => emit(GameSuccessState(
  //         qs: right, count: count, canAnswer: true, color: borderColors)),
  //   );
  // }

  FutureOr<void> gameAnswerSelected(
      GameAnswerSelected event, Emitter<GameState> emit) async {
    List<Color> borderColors = List.generate(4, (index) => Colors.blueGrey);
    List<Color> borderColorsNew = List.generate(4, (index) => Colors.blueGrey);
    bool isComplete = false;
    if (event.isRight) {
      score++;

      borderColors[event.index] = Colors.green;

      quiz.fold(
        (left) => emit(GameErrorState(error: 'Failed to  change state start')),
        (right) => emit(GameSuccessState(
            users: users,
            qs: right,
            count: count,
            canAnswer: false,
            color: borderColors,
            timerSetting: 'stop',
            time: quizTime)),
      );
    }

    if (!event.isRight) {
      if (event.index > 4) {
        for (int i = 0; i < borderColors.length; i++) {
          if (i == event.asnwerIndex) {
            borderColors[i] = Colors.green;
          } else {
            borderColors[i] = Colors.red;
          }
        }
      } else {
        for (int i = 0; i < borderColors.length; i++) {
          if (i == event.asnwerIndex) {
            borderColors[i] = Colors.green;
          }
        }
        borderColors[event.index] = Colors.red;
      }

      quiz.fold(
        (left) => emit(GameErrorState(error: 'Failed to  change state start')),
        (right) => emit(GameSuccessState(
            users: users,
            qs: right,
            count: count,
            canAnswer: false,
            color: borderColors,
            timerSetting: 'stop',
            time: quizTime)),
      );
    }

    String stringScore = score.toString();
    if (count == 9) {
      isComplete = true;
    }
    print('count is $count, iscomplete is $isComplete');
    addSCore(gameCode, userName, stringScore, isComplete);

    await Future.delayed(Duration(seconds: 3));

    count++;

    quiz.fold(
      (left) => emit(GameErrorState(error: 'Failed to  change state start')),
      (right) => emit(GameSuccessState(
          users: users,
          qs: right,
          count: count,
          canAnswer: true,
          color: borderColorsNew,
          timerSetting: 'reset',
          time: quizTime)),
    );
  }

  FutureOr<void> gameResultsEvent(
      GameResultsEvent event, Emitter<GameState> emit) async {
    late List<User> users;
    bool complete = true;
    emit(GameLoadingState(loadString: "getting results"));
    await Future.delayed(Duration(seconds: 3));
    final score = await getScore(gameCode);

    score.fold(
        (left) => emit(GameErrorState(error: 'Failed to  change state start')),
        (right) => users = right);

    for (int i = 0; i < users.length; i++) {
      if (!users[i].complete) {
        users.remove(users[i]);
        complete = false;
      }
    }
    emit(GameResultsState(users: users, complete: complete));
  }

  FutureOr<void> backToLobbyEvent(
      BackToLobbyEvent event, Emitter<GameState> emit) async {
    emit(GameLoadingState(loadString: "Ending Game....."));
    await Future.delayed(Duration(seconds: 1));
    emit(GameLoadingState(loadString: " Going home....."));
    await Future.delayed(Duration(seconds: 1));
    deleteGame(gameCode);
    emit(BackToLobbyActionState());
  }

  FutureOr<void> gameResultsUpdateEvent(
      GameResultsUpdateEvent event, Emitter<GameState> emit) async {
    late List<User> users;
    bool complete = true;
    final score = await getScore(gameCode);

    score.fold(
        (left) => emit(GameErrorState(error: 'Failed to  change state start')),
        (right) => users = right);

    for (int i = 0; i < users.length; i++) {
      if (!users[i].complete) {
        users.remove(users[i]);
        complete = false;
      }
    }
    emit(GameResultsState(users: users, complete: complete));
  }

  @override
  Future<void> close() {
    socket.closeConnection();
    return super.close();
  }
}

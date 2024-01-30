import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/features/multiplayer/data/MOdels/game_model.dart';
import 'package:footy/features/play_online/business/usecases/add_user_score.dart';
import 'package:footy/features/play_online/business/usecases/delete_game.dart';
import 'package:footy/features/play_online/business/usecases/get_quiz_online.dart';
import 'package:footy/features/play_online/business/usecases/get_score.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final OnlinePlayQuiz gameQuiz;
  final GetScore getScore;
  final AddScore addSCore;
  final DeleteGame deleteGame;
  String gameCode = '';
  String userName = '';
  List<User> users = [];
  int score = 0;
  late Either<Failure, Quize> quiz;

  int count = 0;
  GameBloc(this.gameQuiz, this.getScore, this.addSCore, this.deleteGame)
      : super(GameInitial()) {
    on<GameInitialEvent>(gameInitialEvent);
    // on<GameNextQuestion>(gameNextQuestion);
    on<GameAnswerSelected>(gameAnswerSelected);
    on<GameResultsEvent>(gameResultsEvent);
    on<BackToLobbyEvent>(backToLobbyEvent);
  }

  FutureOr<void> gameInitialEvent(
      GameInitialEvent event, Emitter<GameState> emit) async {
    List<Color> borderColors = List.generate(4, (index) => Colors.blueGrey);
    emit(GameLoadingState(loadString: 'Starting Game'));
    await Future.delayed(Duration(seconds: 3));

    gameCode = event.gameCode;
    userName = event.username;
    quiz = await gameQuiz(event.gameCode);
    quiz.fold(
      (left) => emit(GameErrorState(error: 'Failed to  change state start')),
      (right) => emit(GameSuccessState(
          users: users,
          qs: right,
          count: count,
          canAnswer: true,
          color: borderColors)),
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
    if (event.isRight) {
      score++;
      String stringScore = score.toString();

      addSCore(
        gameCode,
        userName,
        stringScore,
      );

      borderColors[event.index] = Colors.green;

      quiz.fold(
        (left) => emit(GameErrorState(error: 'Failed to  change state start')),
        (right) => emit(GameSuccessState(
            users: users,
            qs: right,
            count: count,
            canAnswer: false,
            color: borderColors)),
      );
    }

    if (!event.isRight) {
      for (int i = 0; i < borderColors.length; i++) {
        if (i == event.asnwerIndex) {
          borderColors[i] = Colors.green;
        }
      }
      borderColors[event.index] = Colors.red;

      quiz.fold(
        (left) => emit(GameErrorState(error: 'Failed to  change state start')),
        (right) => emit(GameSuccessState(
            users: users,
            qs: right,
            count: count,
            canAnswer: false,
            color: borderColors)),
      );
    }
    await Future.delayed(Duration(seconds: 3));

    count++;

    quiz.fold(
      (left) => emit(GameErrorState(error: 'Failed to  change state start')),
      (right) => emit(GameSuccessState(
          users: users,
          qs: right,
          count: count,
          canAnswer: true,
          color: borderColorsNew)),
    );
  }

  FutureOr<void> gameResultsEvent(
      GameResultsEvent event, Emitter<GameState> emit) async {
    emit(GameLoadingState(loadString: "getting results"));
    await Future.delayed(Duration(seconds: 3));
    final score = await getScore(gameCode);
    score.fold(
      (left) => emit(GameErrorState(error: 'Failed to  change state start')),
      (right) => emit(GameResultsState(
        users: right,
      )),
    );
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
}

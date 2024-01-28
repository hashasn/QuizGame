import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/features/play_online/business/usecases/get_quiz_online.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final OnlinePlayQuiz gameQuiz;
  String gameCode = '';
  int count = 0;
  GameBloc(this.gameQuiz) : super(GameInitial()) {
    on<GameInitialEvent>(gameInitialEvent);
    on<GameNextQuestion>(gameNextQuestion);
  }

  FutureOr<void> gameInitialEvent(
      GameInitialEvent event, Emitter<GameState> emit) async {
    emit(GameLoadingState(loadString: 'Starting Game'));
    await Future.delayed(Duration(seconds: 3));

    gameCode = event.gameCode;
    final quiz = await gameQuiz(event.gameCode);
    quiz.fold(
      (left) => emit(GameErrorState(error: 'Failed to  change state start')),
      (right) => emit(GameSuccessState(
        qs: right,
        count: count,
      )),
    );
  }

  FutureOr<void> gameNextQuestion(
      GameNextQuestion event, Emitter<GameState> emit) async {
    print('i am here in bloc');
    count++;
    await Future.delayed(Duration(seconds: 3));

    final quiz = await gameQuiz(gameCode);
    quiz.fold(
      (left) => emit(GameErrorState(error: 'Failed to  change state start')),
      (right) => emit(GameSuccessState(qs: right, count: count)),
    );
  }
}

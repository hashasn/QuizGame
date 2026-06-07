/// BLoC for the single-player offline quiz — handles question progression, answer checking, scoring, and game reset.
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:footy/features/PlayQuiz/Business/usecase/start_quiz.dart';
import 'package:footy/features/PlayQuiz/Data/DataSource/localSelectedQuiz.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/core/Util/compareanswer.dart';
import 'package:footy/core/Util/score.dart';

part 'play_event.dart';
part 'play_state.dart';

class PlayBloc extends Bloc<PlayEvent, PlayState> {
  final startQuiz start;
  late dynamic quizz;
  final Score score;

  PlayBloc(this.start, this.score) : super(PlayInitial()) {
    on<PlayInitialEvent>(playInitialEvent);
    on<OptionSelectedEvent>(optionSelectedEvent);
    on<TimeOutEvent>(timeOutevent);
    on<GameDoneEvent>(gameDoneEvent);
    on<ExitGameEvent>(exitGameEvent);
    on<RetryGameEvent>(retryGameEvent);
  }

  FutureOr<void> playInitialEvent(
      PlayInitialEvent event, Emitter<PlayState> emit) async {
    emit(PlayLoadingState());
    await Future.delayed(Duration(seconds: 1));

    quizz = await start();

    quizz.fold((left) => emit(const PlayErrorState(error: 'Failed to start')),
        (right) => emit(PlaySuccessState(qs: right, score: score.getScore())));
  }

  FutureOr<void> optionSelectedEvent(
      OptionSelectedEvent event, Emitter<PlayState> emit) async {
    if (compareAnswer(event.question, event.option)) {
      score.addScore(1);
      emit(CorrectAnswerStates());
      quizz.fold(
          (left) => emit(const PlayErrorState(error: 'Failed to start')),
          (right) =>
              emit(PlaySuccessState(qs: right, score: score.getScore())));

      await Future.delayed(Duration(seconds: 3));

      emit(NextQuestionStates());
      quizz.fold(
          (left) => emit(const PlayErrorState(error: 'Failed to start')),
          (right) =>
              emit(PlaySuccessState(qs: right, score: score.getScore())));
    } else {
      emit(WrongAnswerStates());

      quizz.fold(
          (left) => emit(const PlayErrorState(error: 'Failed to start')),
          (right) =>
              emit(PlaySuccessState(qs: right, score: score.getScore())));
      await Future.delayed(Duration(seconds: 3));
      emit(NextQuestionStates());
      quizz.fold(
          (left) => emit(const PlayErrorState(error: 'Failed to start')),
          (right) =>
              emit(PlaySuccessState(qs: right, score: score.getScore())));
    }
  }

  FutureOr<void> timeOutevent(
      TimeOutEvent event, Emitter<PlayState> emit) async {
    emit(WrongAnswerStates());
    // Rebuild the UI so the correct answer is highlighted before moving on.
    quizz.fold((left) => emit(const PlayErrorState(error: 'Failed to start')),
        (right) => emit(PlaySuccessState(qs: right, score: score.getScore())));

    await Future.delayed(const Duration(seconds: 3));
    emit(NextQuestionStates());
    quizz.fold((left) => emit(const PlayErrorState(error: 'Failed to start')),
        (right) => emit(PlaySuccessState(qs: right, score: score.getScore())));
  }

  FutureOr<void> gameDoneEvent(GameDoneEvent event, Emitter<PlayState> emit) {
    emit(GameDoneState(score: score.getScore()));
  }

  FutureOr<void> exitGameEvent(ExitGameEvent event, Emitter<PlayState> emit) {
    selectedQuizzes.clear();
    score.clearScore();
    emit(ExitGameState());
  }

  FutureOr<void> retryGameEvent(RetryGameEvent event, Emitter<PlayState> emit) {
    score.clearScore();
    emit(RetryGameState());
    quizz.fold((left) => emit(const PlayErrorState(error: 'Failed to start')),
        (right) => emit(PlaySuccessState(qs: right, score: score.getScore())));
  }
}

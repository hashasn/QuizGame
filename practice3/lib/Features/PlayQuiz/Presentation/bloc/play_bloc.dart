import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:footy/Features/PlayQuiz/Business/usecase/start_quiz.dart';
import 'package:footy/Features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/core/Util/compareanswer.dart';
import 'package:footy/core/error/failure.dart';

part 'play_event.dart';
part 'play_state.dart';

class PlayBloc extends Bloc<PlayEvent, PlayState> {
  final startQuiz start;
  late dynamic quizz;
  PlayBloc(this.start) : super(PlayInitial()) {
    on<PlayInitialEvent>(playInitialEvent);
    on<OptionSelectedEvent>(optionSelectedEvent);
    on<TimeOutEvent>(timeOutevent);
  }

  FutureOr<void> playInitialEvent(
      PlayInitialEvent event, Emitter<PlayState> emit) async {
    emit(PlayLoadingState());
    await Future.delayed(Duration(seconds: 1));

    quizz = await start();

    quizz.fold((left) => emit(const PlayErrorState(error: 'Failed to start')),
        (right) => emit(PlaySuccessState(qs: right)));
  }

  FutureOr<void> optionSelectedEvent(
      OptionSelectedEvent event, Emitter<PlayState> emit) async {
    if (compareAnswer(event.question, event.option)) {
      emit(CorrectAnswerStates());
      quizz.fold((left) => emit(const PlayErrorState(error: 'Failed to start')),
          (right) => emit(PlaySuccessState(qs: right)));
      await Future.delayed(Duration(seconds: 3));
      emit(NextQuestionStates());
      quizz.fold((left) => emit(const PlayErrorState(error: 'Failed to start')),
          (right) => emit(PlaySuccessState(qs: right)));
    } else {
      emit(WrongAnswerStates());

      quizz.fold((left) => emit(const PlayErrorState(error: 'Failed to start')),
          (right) => emit(PlaySuccessState(qs: right)));
      await Future.delayed(Duration(seconds: 3));
      emit(NextQuestionStates());
      quizz.fold((left) => emit(const PlayErrorState(error: 'Failed to start')),
          (right) => emit(PlaySuccessState(qs: right)));
    }
  }

  FutureOr<void> timeOutevent(
      TimeOutEvent event, Emitter<PlayState> emit) async {
    emit(WrongAnswerStates());

    await Future.delayed(Duration(seconds: 1));
    emit(NextQuestionStates());
    quizz.fold((left) => emit(const PlayErrorState(error: 'Failed to start')),
        (right) => emit(PlaySuccessState(qs: right)));
  }
}

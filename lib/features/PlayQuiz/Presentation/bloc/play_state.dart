part of 'play_bloc.dart';

abstract class PlayState extends Equatable {
  const PlayState();

  @override
  List<Object> get props => [];
}

abstract class PlayActionState extends PlayState {}

class PlayInitial extends PlayState {}

class PlayLoadingState extends PlayState {}

class PlaySuccessState extends PlayState {
  final Quize qs;
  final int score;

  const PlaySuccessState({required this.qs, required this.score});
}

class PlayErrorState extends PlayState {
  final String error;

  const PlayErrorState({
    required this.error,
  });
}

class CorrectAnswerStates extends PlayActionState {}

class WrongAnswerStates extends PlayActionState {}

class NextQuestionStates extends PlayActionState {}

class GameDoneState extends PlayActionState {
  final int score;

  GameDoneState({required this.score});
}

class ExitGameState extends PlayActionState {}

class RetryGameState extends PlayActionState {}

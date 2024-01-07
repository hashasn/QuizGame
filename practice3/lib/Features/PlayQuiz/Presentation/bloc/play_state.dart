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

  const PlaySuccessState({required this.qs});
}

class PlayErrorState extends PlayState {
  final String error;

  const PlayErrorState({required this.error});
}

class CorrectAnswerStates extends PlayActionState {}

class WrongAnswerStates extends PlayActionState {}

class NextQuestionStates extends PlayActionState {}

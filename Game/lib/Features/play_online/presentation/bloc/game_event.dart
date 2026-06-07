part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class GameInitialEvent extends GameEvent {
  final String gameCode;
  final String username;

  GameInitialEvent({
    required this.gameCode,
    required this.username,
  });
}

class GameNextQuestion extends GameEvent {}

class GameAnswerSelected extends GameEvent {
  final bool isRight;
  final int index;
  final int answerIndex;

  GameAnswerSelected({
    required this.isRight,
    required this.index,
    required this.answerIndex,
  });
}

class GameResultsEvent extends GameEvent {}

class BackToLobbyEvent extends GameEvent {}

class GameResultsUpdateEvent extends GameEvent {}

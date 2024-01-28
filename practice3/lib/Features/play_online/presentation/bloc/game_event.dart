part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class GameInitialEvent extends GameEvent {
  final String gameCode;

  GameInitialEvent({required this.gameCode});
}

class GameNextQuestion extends GameEvent {}

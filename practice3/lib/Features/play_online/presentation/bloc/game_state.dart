part of 'game_bloc.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object> get props => [];
}

abstract class GameActionState extends GameState {}

class GameInitial extends GameState {}

class GameLoadingState extends GameState {
  final String loadString;

  GameLoadingState({required this.loadString});
}

class GameSuccessState extends GameState {
  final Quize qs;
  final int count;
  final bool canAnswer;
  final List<Color> color;
  final List<User> users;
  final String timerSetting;
  final int time;

  GameSuccessState(
      {required this.qs,
      required this.count,
      required this.canAnswer,
      required this.color,
      required this.users,
      required this.timerSetting,
      required this.time});

  @override
  List<Object> get props => [count, canAnswer];
}

class GameErrorState extends GameState {
  final String error;

  GameErrorState({required this.error});
}

class GameNewQuestionState extends GameActionState {}

class GameResultsState extends GameState {
  final List<User> users;
  final bool complete;

  GameResultsState({required this.users, required this.complete});
  @override
  List<Object> get props => [users];
}

class BackToLobbyActionState extends GameActionState {}

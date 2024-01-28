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

  GameSuccessState({required this.qs, required this.count});

  List<Object> get props => [count];
}

class GameErrorState extends GameState {
  final String error;

  GameErrorState({required this.error});
}

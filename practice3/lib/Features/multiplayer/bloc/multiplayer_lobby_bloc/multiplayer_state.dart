part of 'multiplayer_bloc.dart';

abstract class MultiplayerState extends Equatable {
  const MultiplayerState();

  @override
  List<Object> get props => [];
}

abstract class MultiplayerActionState extends MultiplayerState {}

class MultiplayerInitial extends MultiplayerState {}

class LobbyLoadingstate extends MultiplayerState {
  final String loadingString;

  LobbyLoadingstate({required this.loadingString});
}

class SuccessState extends MultiplayerState {
  final WaitingLobbyUser players;

  const SuccessState({required this.players});
}

class LobbyErrorState extends MultiplayerState {
  final String error;

  const LobbyErrorState({required this.error});
}

class LobbyChangedstate extends MultiplayerState {
  final WaitingLobbyUser newPlayers;
  final Quizzes quizzes;

  LobbyChangedstate({required this.newPlayers, required this.quizzes});

  @override
  List<Object> get props => [newPlayers];
}

class NewPLayerJoinedActionState extends MultiplayerActionState {}

class LeaveGameActionState extends MultiplayerActionState {}

class StartGameActionState extends MultiplayerActionState {
  final String username;
  final int time;
  final int count;
  StartGameActionState(
      {required this.username, required this.time, required this.count});
  @override
  List<Object> get props => [count];
}

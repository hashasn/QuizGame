part of 'join_lobby_bloc.dart';

abstract class JoinLobbyState extends Equatable {
  const JoinLobbyState();

  @override
  List<Object> get props => [];
}

abstract class JoinLobbyActionState extends JoinLobbyState {}

final class JoinLobbyInitial extends JoinLobbyState {}

class JoinLobbyLoadingState extends JoinLobbyState {
  final String loadingString;

  const JoinLobbyLoadingState({required this.loadingString});
  @override
  List<Object> get props => [loadingString];
}

class JoinLobbySuccesState extends JoinLobbyState {
  final WaitingLobbyUser players;

  const JoinLobbySuccesState({required this.players});
}

class JoinLobbyChangedState extends JoinLobbyState {
  final WaitingLobbyUser newPlayers;

  JoinLobbyChangedState({required this.newPlayers});
  @override
  List<Object> get props => [newPlayers];
}

class JoinLobbyErrorState extends JoinLobbyState {
  final String error;

  JoinLobbyErrorState({required this.error});
}

class JoinLobbyLeaveGameState extends JoinLobbyActionState {}

class JoinLobbyGameStartActionState extends JoinLobbyActionState {
  final String username;

  JoinLobbyGameStartActionState({required this.username});
}

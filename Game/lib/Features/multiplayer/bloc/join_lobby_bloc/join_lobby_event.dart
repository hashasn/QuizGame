part of 'join_lobby_bloc.dart';

abstract class JoinLobbyEvent extends Equatable {
  const JoinLobbyEvent();

  @override
  List<Object> get props => [];
}

class JoinLobbyInitialEvent extends JoinLobbyEvent {
  final String name;
  final String code;

  const JoinLobbyInitialEvent({required this.name, required this.code});
}

class JoinLobbyChangedEvent extends JoinLobbyEvent {}

class JoinPlayerLeftEvent extends JoinLobbyEvent {}

class JoinLobbyHostLeftGameEvent extends JoinLobbyEvent {}

class JoinLobbyGameStartEvent extends JoinLobbyEvent {}

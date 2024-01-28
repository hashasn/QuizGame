part of 'multiplayer_bloc.dart';

abstract class MultiplayerEvent extends Equatable {
  const MultiplayerEvent();

  @override
  List<Object> get props => [];
}

class LobbyInitialEvent extends MultiplayerEvent {
  final String name;
  final String code;

  const LobbyInitialEvent({required this.name, required this.code});
}

class LobbychangedEvent extends MultiplayerEvent {}

class LobbyNewPlayerInitialEvent extends MultiplayerEvent {
  final String name;
  final String code;

  LobbyNewPlayerInitialEvent({required this.name, required this.code});
}

class LeaveGameEvent extends MultiplayerEvent {}

class StartGameEvent extends MultiplayerEvent {
  final String id;
  final WaitingLobbyUser players;

  StartGameEvent({required this.id, required this.players});
}

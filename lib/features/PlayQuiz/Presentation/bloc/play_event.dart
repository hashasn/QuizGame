part of 'play_bloc.dart';

abstract class PlayEvent extends Equatable {
  const PlayEvent();

  @override
  List<Object> get props => [];
}

class PlayInitialEvent extends PlayEvent {}

class OptionSelectedEvent extends PlayEvent {
  final String option;
  final Question question;

  const OptionSelectedEvent({required this.option, required this.question});
}

class TimeOutEvent extends PlayEvent {}

class GameDoneEvent extends PlayEvent {}

class ExitGameEvent extends PlayEvent {}

class RetryGameEvent extends PlayEvent {}

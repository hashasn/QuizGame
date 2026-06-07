part of 'quizzes_bloc.dart';

abstract class QuizzesEvent extends Equatable {
  const QuizzesEvent();

  @override
  List<Object> get props => [];
}

class QuizzesInitialEvent extends QuizzesEvent {}

class QuizzesButtonClickedEvent extends QuizzesEvent {
  final Quize selectedQuiz;

  const QuizzesButtonClickedEvent({required this.selectedQuiz});
}

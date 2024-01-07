part of 'quizzes_bloc.dart';

abstract class QuizzesState extends Equatable {
  const QuizzesState();

  @override
  List<Object> get props => [];
}

class QuizzesInitial extends QuizzesState {}

class LoadingState extends QuizzesState {}

class SuccessState extends QuizzesState {
  final Quizzes qs;

  const SuccessState({required this.qs});
}

class ErrorState extends QuizzesState {
  final String error;

  const ErrorState({required this.error});
}

class StartQuizzesState extends QuizzesState {}

import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:footy/Features/PlayQuiz/Data/DataSource/localSelectedQuiz.dart';
import 'package:footy/core/error/failure.dart';
import 'package:footy/Features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/Features/Quizzes/Business/UseCases/get_quizzes.dart';
import 'package:injectable/injectable.dart';

part 'quizzes_event.dart';
part 'quizzes_state.dart';

@injectable
class QuizzesBloc extends Bloc<QuizzesEvent, QuizzesState> {
  final GetQuizzes getQuizzes;

  QuizzesBloc(this.getQuizzes) : super(QuizzesInitial()) {
    on<QuizzesInitialEvent>(quizzesInitialEvent);
    on<QuizzesButtonClickedEvent>(quizzesButtonClickedEvent);
  }
  FutureOr<void> quizzesInitialEvent(
      QuizzesInitialEvent event, Emitter<QuizzesState> emit) async {
    emit(LoadingState());
    await Future.delayed(Duration(seconds: 1));
    final quizzes = await getQuizzes();

    quizzes.fold((left) => emit(ErrorState(error: mapFailureToMessage(left))),
        (right) => emit(SuccessState(qs: right)));
  }

  String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server failure';
      case CacheFailure:
        return 'C';
      default:
        return 'Unexpected Error';
    }
  }

  FutureOr<void> quizzesButtonClickedEvent(
      QuizzesButtonClickedEvent event, Emitter<QuizzesState> emit) {
    selectedQuizzes.add(event.selectedQuiz);
    //passQuiz(event.selectedQuiz);
    // emit(StartQuizzesState());
    emit(PlayButtonClickedState());
  }
}

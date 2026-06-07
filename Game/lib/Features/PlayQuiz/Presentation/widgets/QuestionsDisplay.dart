import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footy/features/PlayQuiz/Presentation/Pages/quiz_result_page.dart';
import 'package:footy/features/PlayQuiz/Presentation/bloc/play_bloc.dart';
import 'package:footy/features/PlayQuiz/Presentation/widgets/OptionsContainerWidget.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';
import 'package:linear_timer/linear_timer.dart';

class QuestionsDisplay extends StatelessWidget {
  final Quize qs;
  final int score;
  final int count;
  final LinearTimerController timerController1;
  final bool answeredRight;
  final bool answeredWrong;

  const QuestionsDisplay({
    super.key,
    required this.qs,
    required this.count,
    required this.timerController1,
    required this.answeredRight,
    required this.answeredWrong,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final questions = qs.questions;
    if (count < questions.length) {
      return QuestionPages(
        questions[count],
        context,
        timerController1,
        answeredRight,
        answeredWrong,
        count: count,
        total: questions.length,
      );
    }
    return ResultPage(score: score);
  }
}

Widget QuestionPages(
  Question question,
  BuildContext context,
  LinearTimerController timerController1,
  bool answeredRight,
  bool answeredWrong, {
  int count = 0,
  int total = 0,
}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: LinearTimer(
          duration: const Duration(seconds: 5),
          controller: timerController1,
          backgroundColor: Colors.white12,
          color: Colors.greenAccent,
          onTimerEnd: () {
            BlocProvider.of<PlayBloc>(context).add(TimeOutEvent());
            timerController1.stop();
          },
        ),
      ),
      if (total > 0)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Question ${count + 1} of $total',
            style: const TextStyle(fontSize: 13, color: Colors.white54),
          ),
        ),
      Expanded(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              question.prompt,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      ...question.options.map((opt) => OptionsContainer(
            options: opt,
            q: question,
            answeredWrong: answeredWrong,
            answeredRight: answeredRight,
          )),
      const SizedBox(height: 24),
    ],
  );
}

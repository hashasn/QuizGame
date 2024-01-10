import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footy/Features/PlayQuiz/Presentation/Pages/quiz_result_page.dart';
import 'package:footy/Features/PlayQuiz/Presentation/bloc/play_bloc.dart';
import 'package:footy/Features/PlayQuiz/Presentation/widgets/OptionsContainerWidget.dart';
import 'package:footy/Features/Quizzes/Business/Entities/quizzes.dart';
import 'package:linear_timer/linear_timer.dart';

class QuestionsDisplay extends StatelessWidget {
  final Quize qs;
  final int score;
  final int count;
  final LinearTimerController timerController1;
  final bool answeredRight;
  final bool answeredWrong;

  const QuestionsDisplay(
      {super.key,
      required this.qs,
      required this.count,
      required this.timerController1,
      required this.answeredRight,
      required this.answeredWrong,
      required this.score});

  @override
  Widget build(BuildContext context) {
    final questions = qs.questions;
    if (count < questions.length) {
      return QuestionPages(questions[count], context, timerController1,
          answeredRight, answeredWrong);
    }

    return ResultPage(score: score);
  }
}

Widget QuestionPages(
    Question question,
    BuildContext context,
    LinearTimerController timerController1,
    bool answeredRight,
    bool answeredWrong) {
  return Center(
    child: Column(
      children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // border: Border.all(
            //   color: Colors.black,
            // )
          ),
          child: Text(
            question.prompt,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        OptionsContainer(
          options: question.options[0],
          q: question,
          answeredWrong: answeredWrong,
          answeredRight: answeredRight,
        ),
        OptionsContainer(
          options: question.options[1],
          q: question,
          answeredWrong: answeredWrong,
          answeredRight: answeredRight,
        ),
        OptionsContainer(
          options: question.options[2],
          q: question,
          answeredWrong: answeredWrong,
          answeredRight: answeredRight,
        ),
        OptionsContainer(
          options: question.options[3],
          q: question,
          answeredWrong: answeredWrong,
          answeredRight: answeredRight,
        ),
        Padding(
            padding: const EdgeInsets.all(15),
            child: LinearTimer(
              duration: const Duration(seconds: 5),
              controller: timerController1,
              backgroundColor: Colors.grey,
              onTimerEnd: () {
                BlocProvider.of<PlayBloc>(context).add(TimeOutEvent());
                timerController1.stop();
              },
            )),
      ],
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footy/features/PlayQuiz/Presentation/bloc/play_bloc.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';

class OptionsContainer extends StatelessWidget {
  final String options;
  final Question q;
  final bool answeredRight;
  final bool answeredWrong;

  const OptionsContainer(
      {super.key,
      required this.options,
      required this.q,
      required this.answeredRight,
      required this.answeredWrong});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (answeredRight == false && answeredWrong == false) {
          BlocProvider.of<PlayBloc>(context)
              .add(OptionSelectedEvent(option: options, question: q));
        }
      },
      child: Container(
        // height: 100,
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                width: 3,
                style: BorderStyle.solid,
                color: borderColor(
                    options, q.answers, answeredRight, answeredWrong))),
        child: Text(
          options,
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }
}

Color borderColor(
    String options, String answer, bool answeredRight, bool answeredWrong) {
  if (answeredRight == true) {
    if (options == answer) return Colors.greenAccent;
    return Colors.blueGrey;
  }
  if (answeredWrong == true) {
    if (options == answer) return Colors.greenAccent;
    if (options != answer) return Colors.redAccent;
  }

  return Colors.blueGrey;
}

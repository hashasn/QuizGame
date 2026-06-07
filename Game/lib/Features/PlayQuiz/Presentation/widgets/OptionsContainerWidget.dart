import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footy/features/PlayQuiz/Presentation/bloc/play_bloc.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';

class OptionsContainer extends StatelessWidget {
  final String options;
  final Question q;
  final bool answeredRight;
  final bool answeredWrong;

  const OptionsContainer({
    super.key,
    required this.options,
    required this.q,
    required this.answeredRight,
    required this.answeredWrong,
  });

  @override
  Widget build(BuildContext context) {
    final border =
        _borderColor(options, q.answers, answeredRight, answeredWrong);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        if (!answeredRight && !answeredWrong) {
          BlocProvider.of<PlayBloc>(context)
              .add(OptionSelectedEvent(option: options, question: q));
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
        decoration: BoxDecoration(
          color: border.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(width: 2, color: border),
        ),
        child: Text(
          options,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

Color _borderColor(
    String options, String answer, bool answeredRight, bool answeredWrong) {
  if (answeredRight) {
    return options == answer ? Colors.greenAccent : Colors.white24;
  }
  if (answeredWrong) {
    if (options == answer) return Colors.greenAccent;
    return Colors.redAccent;
  }
  return Colors.white30;
}

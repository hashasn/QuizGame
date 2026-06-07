import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:footy/features/Quizzes/Presentation/Widgets/QuizzesTiles.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';

class QuizzesDisplay extends StatelessWidget {
  final Quizzes qs;

  const QuizzesDisplay({super.key, required this.qs});

  @override
  Widget build(BuildContext context) {
    final quiz = qs.data.quizes;
    return ListView.builder(
      itemCount: quiz.length,
      itemBuilder: (context, index) {
        return QuizzesTiles(quiz: quiz, count: index);
      },
    );
  }
}

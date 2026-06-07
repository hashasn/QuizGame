import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/features/play_online/presentation/bloc/game_bloc.dart';
import 'package:footy/features/play_online/presentation/pages/game_page.dart';
import 'package:linear_timer/linear_timer.dart';

class DisplayQuiz extends StatelessWidget {
  final int count;
  final String gameCode;
  final Quize q;
  final bool reset;
  final List<Color> borderColors;
  final LinearTimerController timerController1;
  final String timerSetting;
  final int time;

  const DisplayQuiz({
    super.key,
    required this.count,
    required this.q,
    required this.reset,
    required this.borderColors,
    required this.gameCode,
    required this.timerController1,
    required this.timerSetting,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    if (count >= q.questions.length) {
      BlocProvider.of<GameBloc>(context).add(GameResultsEvent());
      return const SizedBox.shrink();
    }
    return QuestiosnWidget(
      q: q.questions[count],
      reset: reset,
      borderColors: borderColors,
      timerController1: timerController1,
      timerSetting: timerSetting,
      time: time,
      count: count,
      total: q.questions.length,
    );
  }
}

class QuestiosnWidget extends StatefulWidget {
  final Question q;
  final bool reset;
  final List<Color> borderColors;
  final LinearTimerController timerController1;
  final String timerSetting;
  final int time;
  final int count;
  final int total;

  const QuestiosnWidget({
    super.key,
    required this.q,
    required this.reset,
    required this.borderColors,
    required this.timerController1,
    required this.timerSetting,
    required this.time,
    this.count = 0,
    this.total = 0,
  });

  @override
  State<QuestiosnWidget> createState() => _QuestiosnWidgetState();
}

class _QuestiosnWidgetState extends State<QuestiosnWidget> {
  List<bool> isCorrect = List.generate(4, (index) => false);
  bool selected = false;

  @override
  void setState(VoidCallback fn) {
    selected = false;
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    timerSet(widget.timerSetting, widget.timerController1);
    final answerIndex = _findRightOption(widget.q);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: LinearTimer(
            controller: widget.timerController1,
            duration: Duration(seconds: widget.time),
            backgroundColor: Colors.white12,
            color: Colors.greenAccent,
            onTimerEnd: () {
              BlocProvider.of<GameBloc>(context).add(GameAnswerSelected(
                  isRight: false, index: 10, answerIndex: answerIndex));
            },
          ),
        ),
        if (widget.total > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Question ${widget.count + 1} of ${widget.total}',
              style: const TextStyle(fontSize: 13, color: Colors.white54),
            ),
          ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                widget.q.prompt,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        ...List.generate(
          widget.q.options.length,
          (index) => _optionTile(
              widget.q.options[index], widget.q.answers, index, context, answerIndex),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _optionTile(String option, String answer, int index,
      BuildContext context, int answerIndex) {
    final borderColor = widget.borderColors[index];
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        if (widget.reset) {
          BlocProvider.of<GameBloc>(context).add(GameAnswerSelected(
            isRight: option == answer,
            index: index,
            answerIndex: answerIndex,
          ));
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
        decoration: BoxDecoration(
          color: borderColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(width: 2, color: borderColor),
        ),
        child: Text(
          option,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  int _findRightOption(Question q) {
    for (int i = 0; i < q.options.length; i++) {
      if (q.options[i] == q.answers) return i;
    }
    return 0;
  }
}

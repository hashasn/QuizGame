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
    print(count);
    // print('timer setting is $timerSetting');
    if (count >= q.questions.length) {
      BlocProvider.of<GameBloc>(context).add(GameResultsEvent());
      return Container();
    } else {
      final question = q.questions[count];

      return QuestiosnWidget(
        q: question,
        reset: reset,
        borderColors: borderColors,
        timerController1: timerController1,
        timerSetting: timerSetting,
        time: time,
      );
    }
  }
}

class QuestiosnWidget extends StatefulWidget {
  final Question q;
  final bool reset;
  final List<Color> borderColors;
  final LinearTimerController timerController1;
  final String timerSetting;
  final int time;
  const QuestiosnWidget(
      {super.key,
      required this.q,
      required this.reset,
      required this.borderColors,
      required this.timerController1,
      required this.timerSetting,
      required this.time});

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
    int answerIndex = findRightOption(widget.q);
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
              widget.q.prompt,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30),
          containerWidget(
              widget.q.options[0], widget.q.answers, 0, context, answerIndex),
          containerWidget(
              widget.q.options[1], widget.q.answers, 1, context, answerIndex),
          containerWidget(
              widget.q.options[2], widget.q.answers, 2, context, answerIndex),
          containerWidget(
              widget.q.options[3], widget.q.answers, 3, context, answerIndex),
          const SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.all(15),
            child: LinearTimer(
              controller: widget.timerController1,
              duration: Duration(seconds: widget.time),
              backgroundColor: Colors.grey,
              onTimerEnd: () {
                BlocProvider.of<GameBloc>(context).add(GameAnswerSelected(
                    isRight: false, index: 10, answerIndex: answerIndex));
              },
            ),
          )
        ],
      ),
    );
  }

  Widget containerWidget(String option, String answer, int index,
      BuildContext context, int answerIndex) {
    return InkWell(
      onTap: () {
        if (widget.reset) {
          if (option == answer) {
            BlocProvider.of<GameBloc>(context).add(GameAnswerSelected(
                isRight: true, index: index, answerIndex: answerIndex));
          }
          if (option != answer) {
            BlocProvider.of<GameBloc>(context).add(GameAnswerSelected(
                isRight: false, index: index, answerIndex: answerIndex));
          }
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                width: 3,
                style: BorderStyle.solid,
                color: widget.borderColors[index])),
        child: Text(option),
      ),
    );
  }

  int findRightOption(Question q) {
    int index = 0;
    for (int i = 0; i < q.options.length; i++) {
      if (q.options[i] == q.answers) {
        index = i;
      }
    }
    return index;
  }
}

// import 'package:flutter/material.dart';

// class GamePage extends StatefulWidget {
//   const GamePage({super.key});

//   @override
//   State<GamePage> createState() => _GamePageState();
// }

// class _GamePageState extends State<GamePage> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footy/features/PlayQuiz/Presentation/widgets/loadingWidget.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/features/play_online/presentation/bloc/game_bloc.dart';
import 'package:footy/injection_container.dart';
import 'package:linear_timer/linear_timer.dart';

class GamePage extends StatefulWidget {
  final String gameCode;
  const GamePage({super.key, required this.gameCode});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  late LinearTimerController timerController1 = LinearTimerController(this);

  @override
  void dispose() {
    timerController1.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: buildGameBody(
        code: widget.gameCode,
        context,
        timerController1: timerController1,
      ),
    );
  }
}

class buildGameBody extends StatelessWidget {
  final LinearTimerController timerController1;
  final String code;
  const buildGameBody(BuildContext context,
      {super.key, required this.timerController1, required this.code});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => getIt<GameBloc>(),
        child: BlocConsumer<GameBloc, GameState>(
          listenWhen: (previous, current) => current is GameActionState,
          buildWhen: (previous, current) => current is! GameActionState,
          listener: (context, state) {},
          builder: (context, state) {
            if (state is GameInitial) {
              BlocProvider.of<GameBloc>(context)
                  .add(GameInitialEvent(gameCode: code));
              return LoadingWidget(s: 'Starting game');
            } else if (state is GameLoadingState) {
              return LoadingWidget(s: state.loadString);
            } else if (state is GameSuccessState) {
              return DisplayQuiz(q: state.qs, count: state.count);
            } else {
              return Text('unknownError');
            }
          },
        ));
  }
}

// void timerSet(String setting, LinearTimerController timerController1) {
//   if (setting == 'reset') {
//     Future.delayed(const Duration(milliseconds: 10), () {
//       timerController1.reset();
//       // timerController.reset();
//     });
//   }
//   if (setting == 'start') {
//     Future.delayed(const Duration(milliseconds: 10), () {
//       timerController1.start();
//       // timerController.reset();
//     });
//   }
//   if (setting == 'stop') {
//     Future.delayed(const Duration(milliseconds: 10), () {
//       timerController1.stop();
//       // timerController.reset();
//     });
//   }
// }

class DisplayQuiz extends StatefulWidget {
  final Quize q;
  final int count;
  const DisplayQuiz({super.key, required this.q, required this.count});

  @override
  State<DisplayQuiz> createState() => _DisplayQuizState();
}

class _DisplayQuizState extends State<DisplayQuiz> {
  @override
  Widget build(BuildContext context) {
    print(widget.count);
    if (widget.count <= widget.q.questions.length) {
      final question = widget.q.questions[widget.count];

      return QuestiosnWidget(q: question);
    }

    return const Placeholder();
  }
}

class QuestiosnWidget extends StatefulWidget {
  final Question q;
  const QuestiosnWidget({super.key, required this.q});

  @override
  State<QuestiosnWidget> createState() => _QuestiosnWidgetState();
}

class _QuestiosnWidgetState extends State<QuestiosnWidget> {
  late List<bool> selected;
  late Color color;
  late Color correct;
  late bool alreadySelected;

  @override
  void initState() {
    selected = List.generate(4, (index) => false);
    color = Colors.blueGrey;
    correct = Colors.blueGrey;
    alreadySelected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
            containerWidget(widget.q.options[0], widget.q.answers, 0, context),
            containerWidget(widget.q.options[1], widget.q.answers, 1, context),
            containerWidget(widget.q.options[2], widget.q.answers, 2, context),
            containerWidget(widget.q.options[3], widget.q.answers, 3, context),
          ],
        ),
      ),
    );
  }

  Widget containerWidget(
      String option, String answer, int index, BuildContext context) {
    if (option == answer) {
      setState(() {
        selected[index] = true;
      });
    }
    return InkWell(
      onTap: () {
        if (!alreadySelected) {
          if (option == answer) {
            print('right answer');
            setState(() {
              correct = Colors.green;
              alreadySelected = true;
            });
            BlocProvider.of<GameBloc>(context).add(GameNextQuestion());
          }
          if (option != answer) {
            setState(() {
              color = Colors.red;
              correct = Colors.green;
              alreadySelected = true;
            });
            BlocProvider.of<GameBloc>(context).add(GameNextQuestion());
          }
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                width: 3,
                style: BorderStyle.solid,
                color: selected[index] ? correct : color)),
        child: Text(
          option,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

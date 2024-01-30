import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footy/features/PlayQuiz/Presentation/widgets/loadingWidget.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/features/play_online/presentation/bloc/game_bloc.dart';
import 'package:footy/features/play_online/presentation/pages/game_results_page.dart';
import 'package:footy/injection_container.dart';
import 'package:linear_timer/linear_timer.dart';

class GamePage extends StatefulWidget {
  final String gameCode;
  final String userName;
  const GamePage({super.key, required this.gameCode, required this.userName});

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
        userName: widget.userName,
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
  final String userName;

  const buildGameBody(BuildContext context,
      {super.key,
      required this.timerController1,
      required this.code,
      required this.userName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => getIt<GameBloc>(),
        child: BlocConsumer<GameBloc, GameState>(
          listenWhen: (previous, current) => current is GameActionState,
          buildWhen: (previous, current) => current is! GameActionState,
          listener: (context, state) {
            if (state is BackToLobbyActionState) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is GameInitial) {
              BlocProvider.of<GameBloc>(context)
                  .add(GameInitialEvent(gameCode: code, username: userName));
              return LoadingWidget(s: 'Starting game');
            } else if (state is GameLoadingState) {
              return LoadingWidget(s: state.loadString);
            } else if (state is GameSuccessState) {
              return DisplayQuiz(
                  gameCode: code,
                  q: state.qs,
                  count: state.count,
                  reset: state.canAnswer,
                  borderColors: state.color);
            } else if (state is GameResultsState) {
              return GameResutlsPage(users: state.users);
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

class DisplayQuiz extends StatelessWidget {
  final int count;
  final String gameCode;
  final Quize q;
  final bool reset;
  final List<Color> borderColors;

  const DisplayQuiz({
    super.key,
    required this.count,
    required this.q,
    required this.reset,
    required this.borderColors,
    required this.gameCode,
  });

  @override
  Widget build(BuildContext context) {
    print(count);
    print('reset is $reset');
    if (count >= q.questions.length) {
      BlocProvider.of<GameBloc>(context).add(GameResultsEvent());
      return Container();
    } else {
      final question = q.questions[count];

      return QuestiosnWidget(
        q: question,
        reset: reset,
        borderColors: borderColors,
      );
    }
  }
}

class QuestiosnWidget extends StatefulWidget {
  final Question q;
  final bool reset;
  final List<Color> borderColors;
  const QuestiosnWidget(
      {super.key,
      required this.q,
      required this.reset,
      required this.borderColors});

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
    int asnwerIndex = findRightOption(widget.q);
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
              widget.q.options[0], widget.q.answers, 0, context, asnwerIndex),
          containerWidget(
              widget.q.options[1], widget.q.answers, 1, context, asnwerIndex),
          containerWidget(
              widget.q.options[2], widget.q.answers, 2, context, asnwerIndex),
          containerWidget(
              widget.q.options[3], widget.q.answers, 3, context, asnwerIndex),
        ],
      ),
    );
  }

  Widget containerWidget(String option, String answer, int index,
      BuildContext context, int asnwerIndex) {
    return InkWell(
      onTap: () {
        if (widget.reset) {
          if (option == answer) {
            BlocProvider.of<GameBloc>(context).add(GameAnswerSelected(
                isRight: true, index: index, asnwerIndex: asnwerIndex));
          }
          if (option != answer) {
            BlocProvider.of<GameBloc>(context).add(GameAnswerSelected(
                isRight: false, index: index, asnwerIndex: asnwerIndex));
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

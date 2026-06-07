import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footy/features/PlayQuiz/Presentation/bloc/play_bloc.dart';
import 'package:footy/features/PlayQuiz/Presentation/widgets/QuestionsDisplay.dart';
import 'package:footy/features/PlayQuiz/Presentation/widgets/loadingWidget.dart';
import 'package:footy/injection_container.dart';
import 'package:linear_timer/linear_timer.dart';

class QuizStartPage extends StatefulWidget {
  const QuizStartPage({super.key});

  @override
  State<QuizStartPage> createState() => _QuizStartPageState();
}

class _QuizStartPageState extends State<QuizStartPage>
    with TickerProviderStateMixin {
  late LinearTimerController timerController1 = LinearTimerController(this);

  @override
  void dispose() {
    timerController1.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: buildBody(
        context,
        timerController1: timerController1,
      ),
    );
  }
}

class buildBody extends StatelessWidget {
  final LinearTimerController timerController1;
  const buildBody(BuildContext context,
      {super.key, required this.timerController1});

  @override
  Widget build(BuildContext context) {
    int count = 0;
    bool answeredRight = false;
    bool answeredWrong = false;
    bool reset = true;
    return BlocProvider(
        create: (BuildContext context) => getIt<PlayBloc>(),
        child: BlocConsumer<PlayBloc, PlayState>(
          listenWhen: (previous, current) => current is PlayActionState,
          buildWhen: (previous, current) => current is! PlayActionState,
          listener: (context, state) {
            if (state is CorrectAnswerStates) {
              answeredRight = true;
              answeredWrong = false;
              reset = false;
              timerSet('stop', timerController1);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.greenAccent,
                  content: Text(
                    'correct Answer',
                  ),
                  // backgroundColor:
                  //     Colors.yellow,r
                  duration: Duration(milliseconds: 500),
                ),
              );
            } else if (state is WrongAnswerStates) {
              answeredWrong = true;
              answeredRight = false;
              reset = false;
              timerSet('stop', timerController1);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    'Incorrect Answer',
                    style: TextStyle(color: Colors.red),
                  ),
                  // backgroundColor:
                  //     Colors.yellow,r
                  duration: Duration(milliseconds: 500),
                ),
              );
            } else if (state is NextQuestionStates) {
              timerSet('reset', timerController1);
              count++;
              answeredRight = false;
              answeredWrong = false;
              reset = true;
            } else if (state is ExitGameState) {
              Navigator.pop(context, state);
            } else if (state is RetryGameState) {
              timerSet('reset', timerController1);
              count = 0;
              reset = true;
            }
          },
          builder: (context, state) {
            if (state is PlayInitial) {
              BlocProvider.of<PlayBloc>(context).add(PlayInitialEvent());
              return LoadingWidget(s: 'Starting game');
            } else if (state is PlayLoadingState) {
              return LoadingWidget(s: 'Starting....');
            } else if (state is PlaySuccessState) {
              if (reset) timerSet('start', timerController1);
              if (answeredWrong) timerSet('stop', timerController1);
              return QuestionsDisplay(
                score: state.score,
                qs: state.qs,
                count: count,
                timerController1: timerController1,
                answeredRight: answeredRight,
                answeredWrong: answeredWrong,
              );
            } else if (state is PlayErrorState) {
              return Text(state.error);
            } else {
              return Text('Error occurred');
            }
          },
        ));
  }
}

void timerSet(String setting, LinearTimerController timerController1) {
  if (setting == 'reset') {
    Future.delayed(const Duration(milliseconds: 10), () {
      timerController1.reset();
      // timerController.reset();
    });
  }
  if (setting == 'start') {
    Future.delayed(const Duration(milliseconds: 10), () {
      timerController1.start();
      // timerController.reset();
    });
  }
  if (setting == 'stop') {
    Future.delayed(const Duration(milliseconds: 10), () {
      timerController1.stop();
      // timerController.reset();
    });
  }
}


//  BlocBuilder<PlayBloc, PlayState>(
//         builder: (context, state) {
//          
//         },
//       ),
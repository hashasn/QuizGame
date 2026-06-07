import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footy/features/PlayQuiz/Presentation/widgets/loadingWidget.dart';
import 'package:footy/features/play_online/presentation/bloc/game_bloc.dart';
import 'package:footy/features/play_online/presentation/pages/game_results_page.dart';
import 'package:footy/features/play_online/presentation/widgets/display_online_quiz.dart';
import 'package:footy/injection_container.dart';
import 'package:linear_timer/linear_timer.dart';

class GamePage extends StatefulWidget {
  final String gameCode;
  final String userName;

  const GamePage({
    super.key,
    required this.gameCode,
    required this.userName,
  });

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
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
                borderColors: state.color,
                timerController1: timerController1,
                timerSetting: state.timerSetting,
                time: state.time,
              );
            } else if (state is GameResultsState) {
              return GameResutlsPage(
                users: state.users,
                isComplete: state.complete,
              );
            } else {
              return Text('unknownError');
            }
          },
        ));
  }
}

void timerSet(String setting, LinearTimerController timerController1) {
  if (setting == 'reset') {
    Future.delayed(const Duration(milliseconds: 10), () {
      print('resetting');
      timerController1.reset();
      timerController1.start();
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footy/Features/PlayQuiz/Presentation/bloc/play_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ResultPage extends StatelessWidget {
  final int score;

  const ResultPage({super.key, required this.score});
  Color getColor(int count) {
    if (count > 7) {
      return Colors.green;
    } else if (count < 4) {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(score);
    return Scaffold(
      body: Container(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Quiz Completed',
              style: TextStyle(fontSize: 32),
            ),
            const Text('Your score is  is:'),
            const SizedBox(height: 20),
            Stack(
              children: [
                Container(
                    height: 200,
                    width: 200,

                    //color: Colors.white,
                    child: CircularPercentIndicator(
                      radius: 100.0,
                      lineWidth: 20.0,
                      percent: score / 10,
                      animation: true,
                      //backgroundColor: Color.fromARGB(255, 69, 48, 58),
                      animationDuration: 500,
                      center: Text(
                        '$score/10',
                        style: TextStyle(fontSize: 72),
                      ),
                      progressColor: getColor(score),
                    )),
                // Positioned(
                //   top: 25,
                //   left: 25,
                //   child: Container(
                //     height: 150,
                //     width: 150,
                //     //color: Colors.white,
                //     child: const Center(
                //       child: Text(
                //         '7/10',
                //         style: TextStyle(fontSize: 72),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<PlayBloc>(context).add(ExitGameEvent());
                    },
                    child: Text('Go Home')),
                const SizedBox(width: 30),
                ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<PlayBloc>(context).add(RetryGameEvent());
                    },
                    child: Text('Retry'))
              ],
            ),
          ],
        )),
      ),
    );
  }
}

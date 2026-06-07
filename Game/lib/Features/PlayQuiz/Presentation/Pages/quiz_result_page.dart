import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footy/features/PlayQuiz/Presentation/bloc/play_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ResultPage extends StatelessWidget {
  final int score;

  const ResultPage({super.key, required this.score});

  Color _scoreColor(int count) {
    if (count > 7) return Colors.greenAccent;
    if (count < 4) return Colors.redAccent;
    return Colors.orange;
  }

  String _scoreMessage(int count) {
    if (count > 7) return 'Excellent!';
    if (count < 4) return 'Keep practising';
    return 'Not bad!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                size: 56,
                color: Colors.greenAccent,
              ),
              const SizedBox(height: 16),
              const Text(
                'Quiz Complete!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                _scoreMessage(score),
                style: TextStyle(
                  fontSize: 18,
                  color: _scoreColor(score),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              CircularPercentIndicator(
                radius: 100.0,
                lineWidth: 16.0,
                percent: score / 10,
                animation: true,
                animationDuration: 800,
                center: Text(
                  '$score/10',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                progressColor: _scoreColor(score),
                backgroundColor: Colors.white12,
              ),
              const SizedBox(height: 56),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          BlocProvider.of<PlayBloc>(context)
                              .add(ExitGameEvent());
                        },
                        icon: const Icon(Icons.home_rounded),
                        label: const Text(
                          'Go Home',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white12,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          BlocProvider.of<PlayBloc>(context)
                              .add(RetryGameEvent());
                        },
                        icon: const Icon(Icons.replay_rounded),
                        label: const Text(
                          'Retry',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footy/features/multiplayer/data/MOdels/game_model.dart';
import 'package:footy/features/play_online/presentation/bloc/game_bloc.dart';

class GameResutlsPage extends StatelessWidget {
  final List<User> users;
  final bool isComplete;
  const GameResutlsPage(
      {super.key, required this.users, required this.isComplete});

  Color _medalColor(int index) {
    if (index == 0) return Colors.amber;
    if (index == 1) return Colors.blueGrey[300]!;
    if (index == 2) return const Color(0xFFCD7F32);
    return Colors.white38;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 48),
        const Icon(Icons.leaderboard_rounded,
            size: 48, color: Colors.greenAccent),
        const SizedBox(height: 8),
        const Text(
          'Results',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (!isComplete)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.greenAccent,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Waiting for players to finish...',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ],
          ),
        const SizedBox(height: 16),
        Expanded(
          flex: 3,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final isTopThree = index < 3;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: 12,
                  left: index == 0
                      ? 0
                      : index == 1
                          ? 8
                          : index == 2
                              ? 16
                              : 24,
                  right: index == 0
                      ? 0
                      : index == 1
                          ? 8
                          : index == 2
                              ? 16
                              : 24,
                ),
                child: Material(
                  elevation: isTopThree ? 6 : 2,
                  borderRadius: BorderRadius.circular(14),
                  shadowColor: isTopThree
                      ? _medalColor(index).withOpacity(0.4)
                      : Colors.transparent,
                  child: Container(
                    height: 68,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: isTopThree
                          ? Border.all(
                              color: _medalColor(index).withOpacity(0.5),
                              width: 1.5)
                          : null,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        isTopThree
                            ? Icon(
                                Icons.emoji_events_rounded,
                                size: index == 0 ? 36 : 28,
                                color: _medalColor(index),
                              )
                            : Text(
                                '${index + 1}.',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            user.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: isTopThree
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          user.score,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _medalColor(index),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.maxFinite,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    BlocProvider.of<GameBloc>(context).add(BackToLobbyEvent());
                  },
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text(
                    'Back to Lobby',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

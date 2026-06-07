import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footy/features/PlayQuiz/Presentation/widgets/loadingWidget.dart';
import 'package:footy/features/multiplayer/data/MOdels/waiting_lobby_users_model.dart';
import 'package:footy/features/multiplayer/bloc/join_lobby_bloc/join_lobby_bloc.dart';
import 'package:footy/features/play_online/presentation/pages/game_page.dart';
import 'package:footy/injection_container.dart';

class buildPlayerLobby extends StatelessWidget {
  final String name;
  final String code;

  buildPlayerLobby(BuildContext context,
      {super.key, required this.name, required this.code});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => getIt<JoinLobbyBloc>(),
      child: BlocConsumer<JoinLobbyBloc, JoinLobbyState>(
        listenWhen: (previous, current) => current is JoinLobbyActionState,
        buildWhen: (previous, current) => current is! JoinLobbyActionState,
        listener: (context, state) {
          if (state is JoinLobbyLeaveGameState) {
            Navigator.pop(context, state);
          } else if (state is JoinLobbyGameStartActionState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      // WaitingLobbyPage(name: 'Host', code: code)
                      GamePage(
                        gameCode: code,
                        userName: state.username,
                      )),
            );
          }
        },
        builder: (context, state) {
          if (state is JoinLobbyInitial) {
            BlocProvider.of<JoinLobbyBloc>(context)
                .add(JoinLobbyInitialEvent(name: name, code: code));

            return const CircularProgressIndicator();
          } else if (state is JoinLobbyLoadingState) {
            return LoadingWidget(s: state.loadingString);
          } else if (state is JoinLobbySuccesState) {
            //print(state.players.length);

            final WaitingLobbyUser players = state.players;

            return PlayerLobbyWidget(players: players);
          } else if (state is JoinLobbyChangedState) {
            //  Set
            final WaitingLobbyUser players = state.newPlayers;

            return PlayerLobbyWidget(players: players);
          } else if (state is JoinLobbyErrorState) {
            return Text(state.error);
          } else {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error Occured'),
                ElevatedButton(
                    onPressed: () {
                      // BlocProvider.of<QuizzesBloc>(context)
                      //     .add(QuizzesInitialEvent());
                    },
                    child: Text('retry'))
              ],
            ));
          }
        },
      ),
    );
  }
}

class PlayerLobbyWidget extends StatefulWidget {
  final WaitingLobbyUser players;

  const PlayerLobbyWidget({super.key, required this.players});

  @override
  State<PlayerLobbyWidget> createState() => _PlayerLobbyWidgetState();
}

class _PlayerLobbyWidgetState extends State<PlayerLobbyWidget> {
  int length = 0;
  int currentPageIndex = 0;
  late WaitingLobbyUser newUsers;

  @override
  Widget build(BuildContext context) {
    newUsers = widget.players;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 8),
            child: Row(
              children: [
                const Icon(Icons.group_rounded, color: Colors.greenAccent),
                const SizedBox(width: 8),
                Text(
                  'Players (${newUsers.users.length})',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(
              children: [
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
                  'Waiting for host to start...',
                  style: TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: newUsers.users.length,
              itemBuilder: (context, index) {
                final name = newUsers.users[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(14),
                    shadowColor: Colors.greenAccent.withOpacity(0.2),
                    child: Container(
                      height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          CircleAvatar(
                            backgroundColor: Colors.green[800],
                            child: Text(
                              name.isNotEmpty ? name[0].toUpperCase() : '?',
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(name, style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.maxFinite,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  BlocProvider.of<JoinLobbyBloc>(context)
                      .add(JoinPlayerLeftEvent());
                },
                icon: const Icon(Icons.exit_to_app_rounded),
                label: const Text(
                  'Leave Game',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[900],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

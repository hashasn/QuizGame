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
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: newUsers.users.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(20),
                    child: Material(
                        elevation: 12,
                        borderRadius: BorderRadius.circular(12),
                        shadowColor: Colors.greenAccent,
                        child: Center(
                            child: Container(
                                height: 80,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  //  border: Border.all(color: Colors.black)
                                ),
                                child: Row(children: [
                                  SizedBox(width: 12),
                                  Icon(
                                    Icons.account_box_outlined,
                                    size: 40,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    newUsers.users[index],
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ])))),
                  );
                }),
          ),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
              onPressed: () {
                BlocProvider.of<JoinLobbyBloc>(context)
                    .add(JoinPlayerLeftEvent());
              },
              child: Text('LEAVE GAME'))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footy/features/PlayQuiz/Presentation/widgets/loadingWidget.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/features/multiplayer/data/MOdels/waiting_lobby_users_model.dart';
import 'package:footy/features/multiplayer/Presentation/widgets/game_setting_widget.dart';
import 'package:footy/features/multiplayer/Presentation/widgets/lobby_player_list.dart';
import 'package:footy/features/multiplayer/bloc/multiplayer_lobby_bloc/multiplayer_bloc.dart';
import 'package:footy/features/play_online/presentation/pages/game_page.dart';
import 'package:footy/injection_container.dart';

class buildBody extends StatelessWidget {
  final String name;
  final String code;

  buildBody(BuildContext context,
      {super.key, required this.name, required this.code});

  @override
  Widget build(BuildContext context) {
    print('back here');
    return BlocProvider(
      create: (BuildContext context) => getIt<MultiplayerBloc>(),
      child: BlocConsumer<MultiplayerBloc, MultiplayerState>(
        listenWhen: (previous, current) => current is MultiplayerActionState,
        buildWhen: (previous, current) => current is! MultiplayerActionState,
        listener: (context, state) {
          if (state is NewPLayerJoinedActionState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                //  backgroundColor: Colors.green,
                content: Text(
                  'new player has joined',
                  //style: TextStyle(c),
                ),
                // backgroundColor:
                //     Colors.yellow,r
              ),
            );
          } else if (state is LeaveGameActionState) {
            Navigator.pop(context, state);
          } else if (state is StartGameActionState) {
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
          if (state is MultiplayerInitial) {
            BlocProvider.of<MultiplayerBloc>(context)
                .add(LobbyInitialEvent(name: name, code: code));

            return const CircularProgressIndicator();
          } else if (state is LobbyLoadingstate) {
            return LoadingWidget(s: state.loadingString);
          } else if (state is LobbyChangedstate) {
            //  Set
            final WaitingLobbyUser players = state.newPlayers;
            final Quizzes quizzes = state.quizzes;

            return LobbyWidget(
              players: players,
              quizzes: quizzes,
            );
          } else if (state is LobbyErrorState) {
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

const List<String> timeOptions = <String>['5', '10', '15', '20'];

class LobbyWidget extends StatefulWidget {
  final Quizzes quizzes;
  final WaitingLobbyUser players;

  const LobbyWidget({super.key, required this.players, required this.quizzes});

  @override
  State<LobbyWidget> createState() => _LobbyWidgetState();
}

class _LobbyWidgetState extends State<LobbyWidget> {
  int currentPageIndex = 0;
  late Quize selectedQuiz;
  late WaitingLobbyUser newUsers;
  bool selected = false;

  List<bool> selectedList = List.generate(5, (index) => false);

  String dropdownValue = timeOptions.first;

  @override
  void initState() {
    // selected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    newUsers = widget.players;
    return Scaffold(
        bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            indicatorColor: Colors.greenAccent,
            selectedIndex: currentPageIndex,
            destinations: const <Widget>[
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.account_box_outlined,
                ),
                icon: Icon(Icons.home_outlined),
                label: 'lobby',
              ),
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.settings_accessibility_outlined,
                ),
                icon: Icon(Icons.home_outlined),
                label: 'game settings',
              ),
            ]),
        body: <Widget>[
          LobbyPlayerList(newUsers: newUsers),
          GameSettingWidget(
            quizzes: widget.quizzes,
            players: newUsers,
          )
        ][currentPageIndex]);
  }
}

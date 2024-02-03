import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footy/features/multiplayer/data/MOdels/game_model.dart';
import 'package:footy/features/play_online/presentation/bloc/game_bloc.dart';

class GameResutlsPage extends StatelessWidget {
  final List<User> users;
  final bool isComplete;
  const GameResutlsPage(
      {super.key, required this.users, required this.isComplete});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Game Result',
            style: TextStyle(fontSize: 30),
          ),
          Expanded(
            flex: 3,
            // height: 500,
            // width: 350,
            // decoration: BoxDecoration(
            //     color: Color.fromARGB(95, 57, 76, 52),
            //     borderRadius: BorderRadius.circular(12)),
            child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: (index == 0)
                          ? EdgeInsets.only(
                              left: 20, right: 20, top: 20, bottom: 20)
                          : (index == 1)
                              ? EdgeInsets.only(
                                  left: 25, right: 25, top: 20, bottom: 20)
                              : EdgeInsets.only(
                                  left: 30, right: 30, top: 20, bottom: 20),
                      child: Container(
                        height: 80,
                        // decoration: BoxDecoration(
                        //border: Border.all(color: Colors.black)),
                        child: Row(
                          children: [
                            (index > 2)
                                ? Text(
                                    '${index + 1}.',
                                    style: TextStyle(fontSize: 25),
                                  )
                                : Icon(Icons.emoji_events,
                                    size: (index == 0)
                                        ? 45
                                        : (index == 1)
                                            ? 40
                                            : 30,
                                    color: (index == 0)
                                        ? Colors.amber
                                        : (index == 1)
                                            ? Colors.grey
                                            : Color.fromARGB(255, 139, 80, 12)),
                            const SizedBox(
                              width: 10,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Text(
                              users[index].name,
                              style: TextStyle(fontSize: 30),
                            )),
                            Text(
                              users[index].score,
                              style: TextStyle(fontSize: 30),
                            )
                          ],
                        ),
                      ));
                }),
          ),
          Text(isComplete ? '' : 'Waiting for players to finish'),
          Expanded(
              flex: 2,
              child: Container(
                child: Center(
                  child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<GameBloc>(context)
                            .add(BackToLobbyEvent());
                      },
                      child: Text('back to lobby')),
                ),
              ))
        ],
      ),
    );
  }
}

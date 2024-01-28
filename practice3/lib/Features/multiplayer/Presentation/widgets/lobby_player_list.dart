import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footy/features/multiplayer/bloc/multiplayer_lobby_bloc/multiplayer_bloc.dart';
import 'package:footy/features/multiplayer/data/MOdels/waiting_lobby_users_model.dart';

class LobbyPlayerList extends StatefulWidget {
  final WaitingLobbyUser newUsers;
  const LobbyPlayerList({super.key, required this.newUsers});

  @override
  State<LobbyPlayerList> createState() => _LobbyPlayerListState();
}

class _LobbyPlayerListState extends State<LobbyPlayerList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: widget.newUsers.users.length,
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
                                  widget.newUsers.users[index],
                                  style: TextStyle(fontSize: 30),
                                ),
                              ])))),
                );
              }),
        ),
        SizedBox(
          height: 30,
        ),
        ElevatedButton(
            onPressed: () {
              BlocProvider.of<MultiplayerBloc>(context).add(LeaveGameEvent());
            },
            child: Text('LEAVE GAME'))
      ],
    );
  }
}

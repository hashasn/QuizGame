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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Row(
            children: [
              const Icon(Icons.group_rounded, color: Colors.greenAccent),
              const SizedBox(width: 8),
              Text(
                'Players (${widget.newUsers.users.length})',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.newUsers.users.length,
            itemBuilder: (context, index) {
              final name = widget.newUsers.users[index];
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
                        if (index == 0) ...[
                          const Spacer(),
                          Chip(
                            label: const Text(
                              'Host',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: Colors.greenAccent,
                            padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          const SizedBox(width: 12),
                        ],
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
                BlocProvider.of<MultiplayerBloc>(context).add(LeaveGameEvent());
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
    );
  }
}

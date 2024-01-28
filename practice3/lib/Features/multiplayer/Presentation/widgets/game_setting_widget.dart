import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/features/multiplayer/bloc/multiplayer_lobby_bloc/multiplayer_bloc.dart';
import 'package:footy/features/multiplayer/data/MOdels/waiting_lobby_users_model.dart';

class GameSettingWidget extends StatefulWidget {
  final Quizzes quizzes;
  final WaitingLobbyUser players;
  const GameSettingWidget(
      {super.key, required this.quizzes, required this.players});

  @override
  State<GameSettingWidget> createState() => _GameSettingWidgetState();
}

const List<String> timeOptions = <String>['5', '10', '15', '20'];

class _GameSettingWidgetState extends State<GameSettingWidget> {
  List<bool> selectedList = List.generate(5, (index) => false);
  String dropdownValue = timeOptions.first;
  late Quize selectedQuiz;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Text('Select a game '),
          Container(
            height: 400,
            child: ListView.builder(
              //scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                    padding: EdgeInsets.all(12),
                    child: AnimatedContainer(
                        height: selectedList[index] ? 100 : 70,
                        width: selectedList[index] ? 200 : 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: selectedList[index]
                                    ? Colors.green
                                    : Colors.white),
                            image: DecorationImage(
                                opacity: selectedList[index] ? 0.7 : 0.2,
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    widget.quizzes.data.quizes[index].image))),
                        duration: const Duration(microseconds: 500),
                        curve: Curves.fastOutSlowIn,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.quizzes.data.quizes[index].title,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: selectedList[index]
                                    ? Colors.redAccent
                                    : Colors.white,
                                side: BorderSide(
                                  color: selectedList[index]
                                      ? Colors.redAccent
                                      : Colors.white,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedQuiz =
                                      widget.quizzes.data.quizes[index];
                                  if (selectedList[index]) {
                                    selectedList[index] = false;
                                  } else {
                                    selectedList[index] = true;
                                    for (int i = 0;
                                        i < selectedList.length;
                                        i++) {
                                      if (index != i) {
                                        selectedList[i] = false;
                                      }
                                    }
                                  }
                                });
                              },
                              child: Text(
                                  selectedList[index] ? 'Cancel' : 'Select'),
                            ),
                          ],
                        )));
              },
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text('set a time'),
          DropdownMenu<String>(
            initialSelection: timeOptions.first,
            onSelected: (String? value) {
              setState(() {
                print(value!);
                dropdownValue = value;
              });
            },
            dropdownMenuEntries:
                timeOptions.map<DropdownMenuEntry<String>>((String value) {
              return DropdownMenuEntry<String>(value: value, label: value);
            }).toList(),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                BlocProvider.of<MultiplayerBloc>(context).add(StartGameEvent(
                    id: selectedQuiz.id, players: widget.players));
              },
              child: Text('Start Game'))
        ],
      ),
    );
  }
}

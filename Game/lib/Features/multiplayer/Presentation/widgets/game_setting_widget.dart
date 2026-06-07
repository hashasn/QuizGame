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
  int? selectedIndex;
  String dropdownValue = timeOptions.first;
  late Quize selectedQuiz;

  @override
  Widget build(BuildContext context) {
    final quizCount = widget.quizzes.data.quizes.length > 5
        ? 5
        : widget.quizzes.data.quizes.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Text(
            'Select a Quiz',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: quizCount,
            itemBuilder: (context, index) {
              final quiz = widget.quizzes.data.quizes[index];
              final isSelected = selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedIndex = null;
                    } else {
                      selectedIndex = index;
                      selectedQuiz = quiz;
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  height: isSelected ? 96 : 72,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? Colors.greenAccent : Colors.white24,
                      width: isSelected ? 2 : 1,
                    ),
                    image: DecorationImage(
                      opacity: isSelected ? 0.5 : 0.2,
                      fit: BoxFit.cover,
                      image: NetworkImage(quiz.image),
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          quiz.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.check_circle_rounded,
                            color: Colors.greenAccent,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Text(
            'Time per question (seconds)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: DropdownMenu<String>(
            initialSelection: timeOptions.first,
            width: double.maxFinite,
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white10,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onSelected: (String? value) {
              if (value != null) setState(() => dropdownValue = value);
            },
            dropdownMenuEntries:
                timeOptions.map<DropdownMenuEntry<String>>((String value) {
              return DropdownMenuEntry<String>(
                value: value,
                label: '$value seconds',
              );
            }).toList(),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.maxFinite,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: selectedIndex != null
                  ? () {
                      BlocProvider.of<MultiplayerBloc>(context).add(
                        StartGameEvent(
                          id: selectedQuiz.id,
                          players: widget.players,
                          time: dropdownValue,
                        ),
                      );
                    }
                  : null,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text(
                'Start Game',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
                disabledBackgroundColor: Colors.white12,
                disabledForegroundColor: Colors.white38,
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

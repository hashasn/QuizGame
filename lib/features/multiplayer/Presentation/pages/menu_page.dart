import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:footy/features/Quizzes/Presentation/pages/QuizzesPage.dart';
import 'package:footy/features/multiplayer/Presentation/pages/host_game_page.dart';
import 'package:footy/features/multiplayer/Presentation/pages/join_game_page.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            // title: Text('Menu'),
            ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'QUIZY',
                style: GoogleFonts.roboto(
                  //textStyle: Theme.of(context).textTheme.displayLarge,
                  fontSize: 72,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 70,
                width: 190,
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  elevation: 12,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyWidget()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 12,
                        side: BorderSide(color: Colors.red, width: 5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text(
                      'Play Local',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 70,
                width: 190,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const JoinGame()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      // foregroundColor: MaterialStateProperty.all(Colors.black),
                      // backgroundColor:
                      //     MaterialStateProperty.all(Colors.blue[200]),
                      elevation: 12,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text(
                    'Join Game',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 70,
                width: 190,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HostGameWidget()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 12,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text(
                    'Host Game',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

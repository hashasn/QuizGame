import 'package:flutter/material.dart';
import 'package:footy/features/multiplayer/Presentation/pages/player_waiting_lobby_page.dart';

class JoinGame extends StatelessWidget {
  const JoinGame({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    late String gamecode;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Game'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.login_rounded,
                  size: 64,
                  color: Colors.greenAccent,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Enter Game Code',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ask the host for the 5-character code',
                  style: TextStyle(fontSize: 14, color: Colors.white54),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  textCapitalization: TextCapitalization.characters,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                  decoration: InputDecoration(
                    hintText: 'XXXXX',
                    hintStyle: const TextStyle(
                      color: Colors.white24,
                      letterSpacing: 8,
                    ),
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Colors.greenAccent,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.redAccent),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.redAccent),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a game code';
                    }
                    gamecode = value;
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 56,
                  width: double.maxFinite,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => buildPlayerLobby(
                              context,
                              name: 'User',
                              code: gamecode,
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text(
                      'Join Game',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

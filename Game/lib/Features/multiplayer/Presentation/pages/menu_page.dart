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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B5E20), Color(0xFF0A0A0A)],
            stops: [0.0, 0.65],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.quiz_rounded,
                    size: 72,
                    color: Colors.greenAccent,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'QUIZY',
                    style: GoogleFonts.roboto(
                      fontSize: 72,
                      fontWeight: FontWeight.w900,
                      color: Colors.greenAccent,
                      letterSpacing: 8,
                    ),
                  ),
                  const Text(
                    'Challenge your friends',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white54,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 64),
                  _MenuButton(
                    label: 'Play Local',
                    icon: Icons.person_rounded,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyWidget()),
                    ),
                    isPrimary: true,
                  ),
                  const SizedBox(height: 16),
                  _MenuButton(
                    label: 'Join Game',
                    icon: Icons.login_rounded,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const JoinGame()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _MenuButton(
                    label: 'Host Game',
                    icon: Icons.wifi_tethering_rounded,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HostGameWidget()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _MenuButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.maxFinite,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isPrimary ? Colors.greenAccent : Colors.green[800],
          foregroundColor: isPrimary ? Colors.black : Colors.white,
          elevation: 8,
          shadowColor: Colors.greenAccent.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

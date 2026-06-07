import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:footy/features/multiplayer/Presentation/pages/waiting_lobby_room_page.dart';

class HostGameWidget extends StatelessWidget {
  const HostGameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final Random rnd = Random.secure();
    String getRandomString(int length) => String.fromCharCodes(
          Iterable.generate(
              length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
        );
    final code = getRandomString(5);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Host Game'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_tethering_rounded,
                size: 64,
                color: Colors.greenAccent,
              ),
              const SizedBox(height: 24),
              const Text(
                'Your Game Code',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Share this with friends so they can join',
                style: TextStyle(fontSize: 14, color: Colors.white54),
              ),
              const SizedBox(height: 40),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.greenAccent, width: 2),
                ),
                child: Text(
                  code.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 12,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Code copied to clipboard')),
                  );
                },
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: const Text('Copy code'),
                style: TextButton.styleFrom(foregroundColor: Colors.white54),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 56,
                width: double.maxFinite,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            buildBody(context, name: 'Host', code: code),
                      ),
                    );
                  },
                  icon: const Icon(Icons.group_rounded),
                  label: const Text(
                    'Create Lobby',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
    );
  }
}

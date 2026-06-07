import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String s;
  const LoadingWidget({super.key, required this.s});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.greenAccent),
            const SizedBox(height: 24),
            Text(
              s,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

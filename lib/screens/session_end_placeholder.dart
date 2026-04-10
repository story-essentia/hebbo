import 'package:flutter/material.dart';

import 'package:hebbo/screens/flanker_game_screen.dart';

class SessionEndPlaceholder extends StatelessWidget {
  const SessionEndPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Session Complete!',
              style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),
            _buildButton(context, 'Play again', Colors.blue, () {
               Navigator.pushReplacement(
                 context,
                 MaterialPageRoute(builder: (_) => const FlankerGameScreen()),
               );
            }),
            const SizedBox(height: 16),
            _buildButton(context, 'See progress', Colors.green, () {
               // Navigation to progress screen (future milestone)
            }),
            const SizedBox(height: 16),
            _buildButton(context, 'Back to menu', Colors.grey.shade800, () {
               Navigator.popUntil(context, (route) => route.isFirst);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 240,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}

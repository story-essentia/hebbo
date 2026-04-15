import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hebbo/screens/flanker_game_screen.dart';
import 'package:hebbo/screens/progress_screen.dart';

class SessionEndPlaceholder extends StatelessWidget {
  const SessionEndPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF150629),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Session Complete!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFEFDFFF),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 48),
                _buildButton(
                  context: context,
                  label: 'Play again',
                  isPrimary: true,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FlankerGameScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildButton(
                  context: context,
                  label: 'See progress',
                  isPrimary: false,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProgressScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildButton(
                  context: context,
                  label: 'Back to menu',
                  isPrimary: false,
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? const Color(0xFFFF8AA7)
            : const Color(0xFF301A4D),
        foregroundColor: isPrimary
            ? const Color(0xFF150629)
            : const Color(0xFFEFDFFF),
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

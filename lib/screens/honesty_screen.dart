import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hebbo/providers/database_provider.dart';
import 'package:hebbo/screens/home_screen.dart';

class HonestyScreen extends ConsumerWidget {
  const HonestyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF150629),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Hebbo',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFFEFDFFF),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              _buildFact(
                icon: Icons.science_outlined,
                text: '3 games. All independently researched.',
              ),
              const SizedBox(height: 24),
              _buildFact(
                icon: Icons.shield_outlined,
                text: 'No data leaves your device. Ever.',
              ),
              const SizedBox(height: 24),
              _buildFact(
                icon: Icons.storage_outlined,
                text: 'Your progress is stored locally. No cloud sync.',
              ),
              const SizedBox(height: 24),
              _buildFact(
                icon: Icons.balance_outlined,
                text: 'We show you the science, but make no medical claims.',
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  final prefs = ref.read(sharedPreferencesProvider);
                  await prefs.setBool('has_seen_honesty_screen', true);

                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8AA7),
                  foregroundColor: const Color(0xFF150629),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(48),
                  ),
                ),
                child: Text(
                  "Let's go",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFact({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFFFF8AA7), size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFFEFDFFF),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

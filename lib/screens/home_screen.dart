import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hebbo/screens/flanker_game_screen.dart';
import 'package:hebbo/widgets/about_hebbo_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF150629),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Training',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFFEFDFFF),
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              _buildGameCard(
                context: context,
                title: 'Flanker',
                subtitle: 'Attention & Inhibition',
                icon: Icons.filter_center_focus,
                isActive: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FlankerGameScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildGameCard(
                context: context,
                title: 'Task Switching',
                subtitle: 'Coming soon',
                icon: Icons.swap_horiz,
                isActive: false,
              ),
              const SizedBox(height: 16),
              _buildGameCard(
                context: context,
                title: 'Spatial Span',
                subtitle: 'Coming soon',
                icon: Icons.grid_view,
                isActive: false,
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const AboutHebboSheet(),
                    );
                  },
                  child: Text(
                    'About Hebbo',
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFFEFDFFF).withValues(alpha: 0.7),
                      fontSize: 16,
                      decoration: TextDecoration.underline,
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

  Widget _buildGameCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    final content = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF301A4D),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFFFF8AA7).withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isActive
                  ? const Color(0xFFFF8AA7)
                  : const Color(0xFFEFDFFF).withValues(alpha: 0.5),
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: isActive
                        ? const Color(0xFFEFDFFF)
                        : const Color(0xFFEFDFFF).withValues(alpha: 0.5),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    color: isActive
                        ? const Color(0xFFFF8AA7)
                        : const Color(0xFFEFDFFF).withValues(alpha: 0.4),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (isActive)
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFFF8AA7),
              size: 20,
            ),
        ],
      ),
    );

    return Opacity(
      opacity: isActive ? 1.0 : 0.5,
      child: isActive ? GestureDetector(onTap: onTap, child: content) : content,
    );
  }
}

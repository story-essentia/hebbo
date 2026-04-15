import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutHebboSheet extends StatelessWidget {
  const AboutHebboSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF291543),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.all(32),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scientific Basis',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFFEFDFFF),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Hebbo\'s training logic is based on well-established cognitive psychology paradigms. However, we make no claims that playing these games will cure or treat any medical condition.',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFFEFDFFF).withValues(alpha: 0.8),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'References:',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFFFF8AA7),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildCitation(
              'Eriksen, B. A., & Eriksen, C. W. (1974). Effects of noise letters upon the identification of a target letter in a nonsearch task. Perception & Psychophysics, 16(1), 143-149.',
            ),
            const SizedBox(height: 8),
            _buildCitation(
              'Rueda, M. R., et al. (2005). Training, maturation, and genetic influences on the development of executive attention. PNAS, 102(41), 14931-14936.',
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Close',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFEFDFFF),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCitation(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(color: Color(0xFFEFDFFF), fontSize: 16),
        ),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFFEFDFFF).withValues(alpha: 0.7),
              fontSize: 12,
              height: 1.4,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}

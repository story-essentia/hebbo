import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hebbo/theme/app_theme.dart';

class AboutHebboSheet extends ConsumerWidget {
  const AboutHebboSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF291543),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.all(32),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Scientific Basis',
                style: AppTextStyles.plusJakarta(
                  color: const Color(0xFFEFDFFF),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Hebbo's training logic is based on well-established cognitive psychology paradigms. However, we make no claims that playing these games will cure or treat any medical condition.",
                style: AppTextStyles.plusJakarta(
                  color: const Color(0xFFEFDFFF).withValues(alpha: 0.8),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'References:',
                style: AppTextStyles.plusJakarta(
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
                'Rogers, R. D., & Monsell, S. (1995). Costs of a predictable switch between simple cognitive tasks. Journal of Experimental Psychology: General, 124(2), 207-231.',
              ),
              const SizedBox(height: 8),
              _buildCitation(
                'Berch, D. B., Krikorian, R., & Huha, E. M. (1998). The Corsi block-tapping task: Methodological and theoretical considerations. Brain and Cognition, 38(3), 317-338.',
              ),
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Close',
                    style: AppTextStyles.plusJakarta(
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
            style: AppTextStyles.plusJakarta(
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

import 'package:flutter/material.dart';
import 'package:hebbo/theme/app_theme.dart';
import 'package:hebbo/widgets/about_hebbo_sheet.dart';
import 'package:hebbo/widgets/flanker_detail_sheet.dart';
import 'package:hebbo/widgets/task_switch_detail_sheet.dart';
import 'package:hebbo/widgets/spatial_span_detail_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showFlankerDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Let the sheet widget handle its own bg/corners
      builder: (context) => const FlankerDetailSheet(),
    );
  }  void _showTaskSwitchDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TaskSwitchDetailSheet(),
    );
  }

  void _showSpatialSpanDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SpatialSpanDetailSheet(),
    );
  }


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
                style: AppTextStyles.plusJakarta(
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
                onTap: () => _showFlankerDetail(context),
              ),
              const SizedBox(height: 16),
              _buildGameCard(
                context: context,
                title: 'Task Switching',
                subtitle: 'Cognitive Flexibility',
                icon: Icons.swap_horiz,
                isActive: true,
                onTap: () => _showTaskSwitchDetail(context),
              ),
              const SizedBox(height: 16),
              _buildGameCard(
                context: context,
                title: 'Spatial Span',
                subtitle: 'Visual-Spatial Memory',
                icon: Icons.grid_view,
                isActive: true,
                onTap: () => _showSpatialSpanDetail(context),
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
                    style: AppTextStyles.plusJakarta(
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
                  style: AppTextStyles.plusJakarta(
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
                  style: AppTextStyles.plusJakarta(
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

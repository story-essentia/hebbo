import 'package:flutter/material.dart';
import 'package:hebbo/theme/app_theme.dart';

class FlankerTutorialSheet extends StatefulWidget {
  const FlankerTutorialSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FlankerTutorialSheet(),
    );
  }

  @override
  State<FlankerTutorialSheet> createState() => _FlankerTutorialSheetState();
}

class _FlankerTutorialSheetState extends State<FlankerTutorialSheet> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: const BoxDecoration(
        color: Color(0xFF150629),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildHandle(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) => setState(() => _currentPage = page),
              children: [
                _buildSciencePage(),
                _buildTargetPage(),
                _buildDistractionPage(),
                _buildFeedbackPage(),
                _buildTrainingPage(),
              ],
            ),
          ),
          _buildNavigation(),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 48,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildSciencePage() {
    return _buildBasePage(
      title: 'The Science',
      description: 'Based on the Eriksen Flanker Task (1974), this task measures your inhibitory control — the ability to suppress irrelevant information to focus on a target.',
      icon: Icons.psychology,
      color: const Color(0xFFFF8AA7),
      buttonLabel: 'How to Play',
    );
  }

  Widget _buildTargetPage() {
    return _buildBasePage(
      title: 'The Target',
      description: 'Look at the fish in the center. Tap the side of the screen matching the direction it is facing.',
      icon: Icons.center_focus_strong,
      color: const Color(0xFF00F0FF),
      buttonLabel: 'The Challenge',
    );
  }

  Widget _buildDistractionPage() {
    return _buildBasePage(
      title: 'The Distraction',
      description: 'Surrounding "flanker" fish may point in the opposite direction. Ignore them! Focus only on the center fish.',
      icon: Icons.visibility_off,
      color: const Color(0xFFFFD54F),
      buttonLabel: 'Visual Cues',
    );
  }

  Widget _buildFeedbackPage() {
    return _buildBasePage(
      title: 'Visual Feedback',
      description: 'Correct taps pulse with light. Errors or slow responses cause the fish to shake. Speed and accuracy both matter.',
      icon: Icons.vibration,
      color: const Color(0xFF00E676),
      buttonLabel: 'Training Goals',
    );
  }

  Widget _buildTrainingPage() {
    return _buildBasePage(
      title: 'Deep Training',
      description: 'As you improve, the fish swim faster and reaction windows shrink. Stay calm and keep your gaze locked on the center.',
      icon: Icons.trending_up,
      color: AppColors.primary,
      buttonLabel: 'Start Training',
    );
  }

  Widget _buildBasePage({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String buttonLabel,
  }) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: color),
          const SizedBox(height: 32),
          Text(
            title,
            style: AppTextStyles.plusJakarta(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.plusJakarta(
              fontSize: 16,
              color: Colors.white70,
              height: 1.6,
            ),
          ),
          const Spacer(),
          _buildNextButton(buttonLabel),
        ],
      ),
    );
  }

  Widget _buildNextButton(String label) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_currentPage < 4) {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          } else {
            Navigator.pop(context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          elevation: 0,
        ),
        child: Text(
          label,
          style: AppTextStyles.plusJakarta(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? AppColors.primary : Colors.white24,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

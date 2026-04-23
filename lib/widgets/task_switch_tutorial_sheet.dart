import 'package:flutter/material.dart';
import 'package:hebbo/theme/app_theme.dart';

class TaskSwitchTutorialSheet extends StatefulWidget {
  const TaskSwitchTutorialSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TaskSwitchTutorialSheet(),
    );
  }

  @override
  State<TaskSwitchTutorialSheet> createState() => _TaskSwitchTutorialSheetState();
}

class _TaskSwitchTutorialSheetState extends State<TaskSwitchTutorialSheet> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: const BoxDecoration(
        color: Color(0xFF150629),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
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
                _buildMagnitudePage(),
                _buildParityPage(),
                _buildSwitchExplanationPage(),
                _buildLevelingPage(),
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
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.science_outlined, color: AppColors.primary, size: 64),
          const SizedBox(height: 32),
          Text(
            'The Science',
            style: AppTextStyles.plusJakarta(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Based on key research by Rogers & Monsell (1995), this task measures "Switch Cost"—the brief moment of hesitation when your brain must swap one logical rule for another.',
            textAlign: TextAlign.center,
            style: AppTextStyles.plusJakarta(
              color: Colors.white70,
              fontSize: 16,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'By training this shift, you improve cognitive flexibility and your ability to transition between complex tasks in real life.',
            textAlign: TextAlign.center,
            style: AppTextStyles.plusJakarta(
              color: Colors.white70,
              fontSize: 16,
              height: 1.6,
            ),
          ),
          const Spacer(),
          _buildNextButton('How to Play'),
        ],
      ),
    );
  }

  Widget _buildMagnitudePage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildOrb(AppColors.neonPink),
          const SizedBox(height: 32),
          Text(
            'Pink: Size',
            style: AppTextStyles.plusJakarta(
              color: AppColors.neonPink,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'When the orb is Pink, ask yourself:\n"Is the number Small or Big?"',
            textAlign: TextAlign.center,
            style: AppTextStyles.plusJakarta(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              _buildSmallStep('Tap Left', '1, 2, 3, 4', AppColors.neonPink),
              const SizedBox(width: 16),
              _buildSmallStep('Tap Right', '6, 7, 8, 9', AppColors.neonPink),
            ],
          ),
          const Spacer(),
          _buildNextButton('Next Rule'),
        ],
      ),
    );
  }

  Widget _buildParityPage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildOrb(AppColors.neonBlue),
          const SizedBox(height: 32),
          Text(
            'Blue: Type',
            style: AppTextStyles.plusJakarta(
              color: AppColors.neonBlue,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'When the orb is Blue, ask yourself:\n"Is the number Odd or Even?"',
            textAlign: TextAlign.center,
            style: AppTextStyles.plusJakarta(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              _buildSmallStep('Tap Left', '1, 3, 7, 9', AppColors.neonBlue),
              const SizedBox(width: 16),
              _buildSmallStep('Tap Right', '2, 4, 6, 8', AppColors.neonBlue),
            ],
          ),
          const Spacer(),
          _buildNextButton('The Challenge'),
        ],
      ),
    );
  }

  Widget _buildSwitchExplanationPage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.sync_alt, color: Color(0xFFFFCC00), size: 64),
          const SizedBox(height: 32),
          Text(
            'The Switch',
            style: AppTextStyles.plusJakarta(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'The color changes randomly. Your brain has to "re-wire" the buttons instantly.',
            textAlign: TextAlign.center,
            style: AppTextStyles.plusJakarta(
              color: Colors.white70,
              fontSize: 16,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Go as fast as you can. Speed and accuracy both matter for your performance score!',
            textAlign: TextAlign.center,
            style: AppTextStyles.plusJakarta(
              color: Colors.white70,
              fontSize: 16,
              height: 1.6,
            ),
          ),
          const Spacer(),
          _buildNextButton('What to Expect'),
        ],
      ),
    );
  }

  Widget _buildLevelingPage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.trending_up, color: Color(0xFFFFCC00), size: 64),
          const SizedBox(height: 32),
          Text(
            'Adaptive Leveling',
            style: AppTextStyles.plusJakarta(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'As you improve, the game adapts. Higher levels bring:',
            textAlign: TextAlign.center,
            style: AppTextStyles.plusJakarta(
              color: Colors.white,
              fontSize: 16,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          _buildLevelFeature(Icons.speed, 'Faster Deadlines', 'Less time to react to stimuli.'),
          const SizedBox(height: 16),
          _buildLevelFeature(Icons.shuffle, 'Frequent Switches', 'Rule changes happen more often.'),
          const Spacer(),
          _buildNextButton('Start Training'),
        ],
      ),
    );
  }

  Widget _buildLevelFeature(IconData icon, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFFCC00), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.plusJakarta(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  desc,
                  style: AppTextStyles.plusJakarta(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrb(Color color) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.6),
            blurRadius: 32,
            spreadRadius: 8,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          '7',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSmallStep(String title, String numbers, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: AppTextStyles.plusJakarta(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              numbers,
              style: AppTextStyles.plusJakarta(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
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

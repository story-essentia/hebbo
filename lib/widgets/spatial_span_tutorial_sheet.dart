import 'package:flutter/material.dart';
import 'package:hebbo/theme/app_theme.dart';

class SpatialSpanTutorialSheet extends StatefulWidget {
  const SpatialSpanTutorialSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SpatialSpanTutorialSheet(),
    );
  }

  @override
  State<SpatialSpanTutorialSheet> createState() => _SpatialSpanTutorialSheetState();
}

class _SpatialSpanTutorialSheetState extends State<SpatialSpanTutorialSheet> {
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
                _buildTrack1Page(),
                _buildTrack2Page(),
                _buildTrack3Page(),
                _buildProgressionPage(),
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
      description: 'Based on the Corsi Block-Tapping task, this game measures and improves your visuospatial working memory — your ability to hold and manipulate spatial information.',
      icon: Icons.psychology,
      color: const Color(0xFFFF8AA7),
      buttonLabel: 'Track 1: Forward Span',
    );
  }

  Widget _buildTrack1Page() {
    return _buildBasePage(
      title: 'Track 1: Forward Span',
      description: 'Watch the sequence of glowing shards and repeat them in the exact same order. This builds your foundational working memory capacity.',
      icon: Icons.looks_one,
      color: AppColors.neonBlue,
      buttonLabel: 'Track 2: Distractor Inhibition',
    );
  }

  Widget _buildTrack2Page() {
    return _buildBasePage(
      title: 'Track 2: Distractor Inhibition',
      description: 'Distracting background shards will pulse randomly while the sequence plays. Ignore the noise and stay focused!',
      icon: Icons.looks_two,
      color: AppColors.neonPink,
      buttonLabel: 'Track 3: Backward Span',
    );
  }

  Widget _buildTrack3Page() {
    return _buildBasePage(
      title: 'Track 3: Backward Span',
      description: 'A severe test of mental manipulation. You must recall and tap the entire sequence in strictly REVERSE order.',
      icon: Icons.looks_3,
      color: AppColors.neonLime,
      buttonLabel: 'Progression',
    );
  }

  Widget _buildProgressionPage() {
    return _buildBasePage(
      title: 'Deep Training',
      description: 'Complete 2 out of 3 trials perfectly to unlock the next span level. Reach Level 7 on a track to unlock its subsequent branch in the Progression Map!',
      icon: Icons.trending_up,
      color: AppColors.primary,
      buttonLabel: 'Explore Map',
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import 'main_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardPage> _pages = [
    _OnboardPage(
      icon: Icons.devices_rounded,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1E3A5F), Color(0xFF2563EB)],
      ),
      title: 'Effortless device\nmanagement',
      subtitle:
          'Control every light, switch, sensor and motor in your home from one app.',
      badge: 'Tuya · Zigbee 3.0 · Wi-Fi · MQTT',
    ),
    _OnboardPage(
      icon: Icons.auto_awesome_motion_rounded,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF065F46), Color(0xFF059669)],
      ),
      title: 'One-tap\nscene control',
      subtitle:
          'Create powerful automations and activate any scene with a single tap.',
      badge: 'Automations · Schedules · Scenes',
    ),
    _OnboardPage(
      icon: Icons.security_rounded,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4C1D95), Color(0xFF7C3AED)],
      ),
      title: 'Protect\nYour Home',
      subtitle:
          'IP65 door stations, face-recognition locks and 24/7 AI-powered security.',
      badge: 'Video Intercom · Smart Locks · AI Protect',
    ),
    _OnboardPage(
      icon: Icons.bolt_rounded,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF92400E), Color(0xFFF59E0B)],
      ),
      title: 'Build an energy-\nefficient home',
      subtitle:
          'AI tracks consumption, finds savings and keeps your bills in check automatically.',
      badge: 'AI Energy Saving · Power Metering',
    ),
    _OnboardPage(
      icon: Icons.auto_awesome_rounded,
      gradient: AppColors.aiGradient,
      title: 'Life AI\nAssistant',
      subtitle:
          'Talk to your home. Control devices, set scenes and get health insights — all with your voice.',
      badge: 'AI Chat · Health · Notes · Translate',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Pages
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, i) => _buildPage(_pages[i]),
          ),

          // Bottom controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  children: [
                    // Page indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == i ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _currentPage == i
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action buttons
                    if (_currentPage < _pages.length - 1) ...[
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _navigateToApp(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  'Skip',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () => _pageController.nextPage(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeInOut,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  'Next',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      GestureDetector(
                        onTap: () => _navigateToApp(context),
                        child: Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            'Get Started',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(_OnboardPage page) {
    return Container(
      decoration: BoxDecoration(gradient: page.gradient),
      padding: const EdgeInsets.fromLTRB(32, 80, 32, 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'THE RANGE',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),

          // Big icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Icon(page.icon, color: Colors.white, size: 52),
          ),

          const SizedBox(height: 32),

          Text(
            page.title,
            style: GoogleFonts.inter(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.15,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            page.subtitle,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              page.badge,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToApp(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainShell(),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}

class _OnboardPage {
  final IconData icon;
  final Gradient gradient;
  final String title;
  final String subtitle;
  final String badge;

  const _OnboardPage({
    required this.icon,
    required this.gradient,
    required this.title,
    required this.subtitle,
    required this.badge,
  });
}

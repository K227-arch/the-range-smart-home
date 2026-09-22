import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_colors.dart';
import 'home_screen.dart';
import 'scenes_screen.dart';
import 'security_screen.dart';
import 'energy_screen.dart';
import 'ai_screen.dart';
import 'products_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.auto_awesome_motion_rounded, label: 'Scenes'),
    _NavItem(icon: Icons.security_rounded, label: 'Protect'),
    _NavItem(icon: Icons.bolt_rounded, label: 'Energy'),
    _NavItem(icon: Icons.auto_awesome_rounded, label: 'AI'),
    _NavItem(icon: Icons.grid_view_rounded, label: 'Products'),
  ];

  static const List<Widget> _screens = [
    HomeScreen(),
    ScenesScreen(),
    SecurityScreen(),
    EnergyScreen(),
    AIScreen(),
    ProductsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isDark = state.isDarkMode;

    return Scaffold(
      body: IndexedStack(
        index: state.currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildNavBar(context, state, isDark),
    );
  }

  Widget _buildNavBar(BuildContext context, AppState state, bool isDark) {
    final navBg = isDark ? AppColors.bgCard : Colors.white;
    final selectedColor = AppColors.primary;
    final unselectedColor =
        isDark ? AppColors.textOnDarkSecondary : AppColors.navUnselected;

    return Container(
      decoration: BoxDecoration(
        color: navBg,
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.07),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // ── Nav tabs ──────────────────────────────────────────────
              ..._navItems.asMap().entries.map((entry) {
                final idx = entry.key;
                final item = entry.value;
                final isSelected = state.currentIndex == idx;

                return GestureDetector(
                  onTap: () => state.setIndex(idx),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? selectedColor.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.icon,
                          size: 22,
                          color: isSelected ? selectedColor : unselectedColor,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color:
                                isSelected ? selectedColor : unselectedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}

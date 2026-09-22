import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/scene_card.dart';

class ScenesScreen extends StatefulWidget {
  const ScenesScreen({super.key});

  @override
  State<ScenesScreen> createState() => _ScenesScreenState();
}

class _ScenesScreenState extends State<ScenesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.home_rounded,
                              size: 20, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            'My Home',
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _iconBtn(Icons.grid_view_rounded, () {}),
                          const SizedBox(width: 8),
                          _iconBtn(Icons.add_rounded, () {}),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Tab bar
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors.textPrimary,
                    unselectedLabelColor: AppColors.textSecondary,
                    labelStyle: GoogleFonts.inter(
                        fontSize: 15, fontWeight: FontWeight.w700),
                    unselectedLabelStyle:
                        GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w400),
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.label,
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: 'Tap-to-run'),
                      Tab(text: 'Automation'),
                    ],
                  ),
                ],
              ),
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _TapToRunTab(state: state),
                  _AutomationTab(state: state),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: AppColors.textPrimary),
        ),
      );
}

class _TapToRunTab extends StatelessWidget {
  final AppState state;

  const _TapToRunTab({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scene grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: state.tapToRunScenes.length,
            itemBuilder: (context, i) {
              final scene = state.tapToRunScenes[i];
              return SceneCard(
                scene: scene,
                onTap: () {
                  state.runScene(scene.id);
                  _showSceneRunSnackbar(context, scene.name);
                },
              );
            },
          ),

          const SizedBox(height: 24),

          // Go Home shortcut banner
          _GoHomeBanner(state: state),

          const SizedBox(height: 16),

          // Add scene button
          _AddSceneButton(),
        ],
      ),
    );
  }

  void _showSceneRunSnackbar(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text('Scene "$name" activated',
                style: GoogleFonts.inter(fontSize: 14)),
          ],
        ),
        backgroundColor: AppColors.active,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _AutomationTab extends StatelessWidget {
  final AppState state;

  const _AutomationTab({required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Go Home section
        _SectionLabel(label: 'Go home'),
        ...state.automationScenes.map(
          (scene) => AutomationRow(
            scene: scene,
            onToggle: () {},
          ),
        ),
        const SizedBox(height: 16),
        _AddSceneButton(label: 'Add Automation'),
      ],
    );
  }
}

class _GoHomeBanner extends StatelessWidget {
  final AppState state;

  const _GoHomeBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Go home',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap to activate welcome home scene',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),
          ...['Turn on all lights', 'Unlock front door', 'AC on 22°C']
              .map((a) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline_rounded,
                            color: Colors.white70, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          a,
                          style: GoogleFonts.inter(
                              fontSize: 13, color: Colors.white),
                        ),
                      ],
                    ),
                  )),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Run Now',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _AddSceneButton extends StatelessWidget {
  final String label;

  const _AddSceneButton({this.label = 'Add Scene'});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
            style: BorderStyle.solid,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

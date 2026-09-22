import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/scene.dart';
import '../theme/app_colors.dart';
import '../theme/theme_helper.dart';
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
    final th = ThemeHelper.of(context);

    return Scaffold(
      backgroundColor: th.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              color: th.topBarBg,
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
                              color: th.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _iconBtn(Icons.grid_view_rounded, () {}),
                          const SizedBox(width: 8),
                          _iconBtn(Icons.add_rounded, () {
                            final isAuto = _tabController.index == 1;
                            _showAddSceneSheet(
                              context,
                              context.read<AppState>(),
                              ThemeHelper.of(context),
                              isAutomation: isAuto,
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Tab bar
                  TabBar(
                    controller: _tabController,
                    labelColor: th.textPrimary,
                    unselectedLabelColor: th.textSecondary,
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
                  _TapToRunTab(state: state, onAddScene: _showAddSceneSheet),
                  _AutomationTab(state: state, onAddScene: _showAddSceneSheet),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    final th = ThemeHelper.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: th.chipBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: th.iconPrimary),
      ),
    );
  }

  // ── Add Scene / Automation bottom sheet ─────────────────────────────────
  void _showAddSceneSheet(
    BuildContext context,
    AppState state,
    ThemeHelper th, {
    required bool isAutomation,
  }) {
    final sceneIcons = [
      {'icon': Icons.wb_sunny_rounded,         'color': const Color(0xFFF59E0B)},
      {'icon': Icons.nightlight_round,         'color': const Color(0xFF6366F1)},
      {'icon': Icons.home_rounded,             'color': const Color(0xFF10B981)},
      {'icon': Icons.directions_walk_rounded,  'color': const Color(0xFFF97316)},
      {'icon': Icons.movie_rounded,            'color': const Color(0xFFEF4444)},
      {'icon': Icons.security_rounded,         'color': const Color(0xFF2563EB)},
      {'icon': Icons.timer_rounded,            'color': const Color(0xFF3B82F6)},
      {'icon': Icons.lightbulb_rounded,        'color': const Color(0xFFF59E0B)},
      {'icon': Icons.music_note_rounded,       'color': const Color(0xFF8B5CF6)},
      {'icon': Icons.air_rounded,              'color': const Color(0xFF06B6D4)},
      {'icon': Icons.cleaning_services_rounded,'color': const Color(0xFF8B5CF6)},
      {'icon': Icons.bedtime_rounded,          'color': const Color(0xFF6366F1)},
    ];

    final triggerOptions = [
      'Tap to run',
      'At a scheduled time',
      'When someone arrives home',
      'When someone leaves home',
      'When a sensor is triggered',
      'When temperature exceeds',
    ];

    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    Map<String, dynamic> selectedIconEntry =
        sceneIcons[0] as Map<String, dynamic>;
    String selectedTrigger = triggerOptions[0];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: th.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                        color: th.divider,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isAutomation ? 'Add Automation' : 'Create Scene',
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: th.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  isAutomation
                      ? 'Set a trigger and let your home react automatically'
                      : 'Name your scene and pick an icon',
                  style: GoogleFonts.inter(
                      fontSize: 13, color: th.textSecondary),
                ),
                const SizedBox(height: 20),

                // Icon picker
                Text('Icon',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: th.textSecondary)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: sceneIcons.map((entry) {
                    final isSel = selectedIconEntry == entry;
                    final color = entry['color'] as Color;
                    return GestureDetector(
                      onTap: () => setSheet(
                          () => selectedIconEntry = entry as Map<String, dynamic>),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSel
                              ? color.withValues(alpha: 0.15)
                              : th.chipBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:
                                isSel ? color : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(entry['icon'] as IconData,
                            size: 22,
                            color: isSel ? color : th.iconPrimary),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Name
                Text('Name',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: th.textSecondary)),
                const SizedBox(height: 8),
                TextField(
                  controller: nameCtrl,
                  style: GoogleFonts.inter(
                      fontSize: 14, color: th.textPrimary),
                  decoration: InputDecoration(
                    hintText: isAutomation
                        ? 'e.g. Night Mode'
                        : 'e.g. Movie Time',
                    hintStyle:
                        GoogleFonts.inter(color: th.textHint),
                    filled: true,
                    fillColor: th.inputFill,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Description (optional)
                Text('Description (optional)',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: th.textSecondary)),
                const SizedBox(height: 8),
                TextField(
                  controller: descCtrl,
                  style: GoogleFonts.inter(
                      fontSize: 14, color: th.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'What does this scene do?',
                    hintStyle:
                        GoogleFonts.inter(color: th.textHint),
                    filled: true,
                    fillColor: th.inputFill,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                // Trigger selector — automation only
                if (isAutomation) ...[
                  const SizedBox(height: 16),
                  Text('Trigger',
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: th.textSecondary)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: th.inputFill,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: triggerOptions.map((t) {
                        final isSel = selectedTrigger == t;
                        return GestureDetector(
                          onTap: () =>
                              setSheet(() => selectedTrigger = t),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSel
                                  ? AppColors.primary
                                      .withValues(alpha: 0.08)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSel
                                      ? Icons.radio_button_checked_rounded
                                      : Icons.radio_button_unchecked_rounded,
                                  size: 18,
                                  color: isSel
                                      ? AppColors.primary
                                      : th.textHint,
                                ),
                                const SizedBox(width: 10),
                                Text(t,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: isSel
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: isSel
                                          ? AppColors.primary
                                          : th.textPrimary,
                                    )),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],

                const SizedBox(height: 28),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final name = nameCtrl.text.trim();
                      if (name.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter a name',
                                style: GoogleFonts.inter()),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12)),
                          ),
                        );
                        return;
                      }
                      state.addScene(Scene(
                        id: 'scene_${DateTime.now().millisecondsSinceEpoch}',
                        name: name,
                        icon: selectedIconEntry['icon'] as IconData,
                        color: selectedIconEntry['color'] as Color,
                        type: isAutomation
                            ? SceneType.automation
                            : SceneType.tapToRun,
                        description: descCtrl.text.trim().isNotEmpty
                            ? descCtrl.text.trim()
                            : null,
                        isEnabled: true,
                      ));
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(children: [
                            const Icon(Icons.check_circle_rounded,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              isAutomation
                                  ? '"$name" automation created'
                                  : '"$name" scene created',
                              style: GoogleFonts.inter(),
                            ),
                          ]),
                          backgroundColor: AppColors.active,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text(
                      isAutomation ? 'Add Automation' : 'Create Scene',
                      style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TapToRunTab extends StatelessWidget {
  final AppState state;
  final void Function(BuildContext, AppState, ThemeHelper, {required bool isAutomation}) onAddScene;

  const _TapToRunTab({required this.state, required this.onAddScene});

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          _GoHomeBanner(state: state),
          const SizedBox(height: 16),
          _AddSceneButton(
            label: 'Add Scene',
            onTap: () => onAddScene(context, state, th, isAutomation: false),
          ),
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
  final void Function(BuildContext, AppState, ThemeHelper, {required bool isAutomation}) onAddScene;

  const _AutomationTab({required this.state, required this.onAddScene});

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionLabel(label: 'Go home'),
        ...state.automationScenes.map(
          (scene) => AutomationRow(scene: scene, onToggle: () {}),
        ),
        const SizedBox(height: 16),
        _AddSceneButton(
          label: 'Add Automation',
          onTap: () => onAddScene(context, state, th, isAutomation: true),
        ),
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
              color: Colors.white.withValues(alpha: 0.8),
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
    final th = ThemeHelper.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: th.textPrimary,
        ),
      ),
    );
  }
}

class _AddSceneButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _AddSceneButton({this.label = 'Add Scene', this.onTap});

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: th.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
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

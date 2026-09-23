import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/device.dart';
import '../theme/app_colors.dart';
import '../theme/theme_helper.dart';

// ─── SnarF brand colour ───────────────────────────────────────────────────────
const Color _snarf = Color(0xFF2563EB);
const Color _snarfDark = Color(0xFF1D4ED8);

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  // ── Glass Touch Switches ────────────────────────────────────────────────────
  static const _switches = [
    _SnarfProduct(
      name: '1 Gang Switch',
      desc: 'Single-button glass touch switch. Controls one light circuit.',
      icon: Icons.toggle_on_rounded,
      tags: ['Wi-Fi', '1 Gang', 'Glass Touch'],
      deviceType: DeviceType.switch_,
    ),
    _SnarfProduct(
      name: '2 Gang Switch',
      desc: 'Two independent touch buttons in one elegant glass panel.',
      icon: Icons.toggle_on_rounded,
      tags: ['Wi-Fi', '2 Gang', 'Glass Touch'],
      deviceType: DeviceType.switch_,
    ),
    _SnarfProduct(
      name: '3 Gang Switch',
      desc: 'Three-button smart switch panel — ideal for multiple lighting zones.',
      icon: Icons.toggle_on_rounded,
      tags: ['Wi-Fi', '3 Gang', 'Glass Touch'],
      deviceType: DeviceType.switch_,
    ),
    _SnarfProduct(
      name: 'Dimming Switch',
      desc: 'Smoothly dim lights from full brightness to a soft glow.',
      icon: Icons.wb_incandescent_rounded,
      tags: ['Wi-Fi', 'Dimmer', 'Scene Control'],
      deviceType: DeviceType.light,
    ),
    _SnarfProduct(
      name: 'Water Heater Switch',
      desc: 'Schedule your water heater — turn off automatically to save energy.',
      icon: Icons.hot_tub_rounded,
      tags: ['Wi-Fi', 'Timer', 'Energy Saving'],
      deviceType: DeviceType.switch_,
    ),
  ];

  // ── Smart Sockets ───────────────────────────────────────────────────────────
  static const _sockets = [
    _SnarfProduct(
      name: '1 Gang Socket',
      desc: 'Single smart socket with real-time power monitoring.',
      icon: Icons.electrical_services_rounded,
      tags: ['Wi-Fi', 'Power Monitoring', '1 Socket'],
      deviceType: DeviceType.socket,
    ),
    _SnarfProduct(
      name: '2 Gang Socket',
      desc: 'Double smart socket with USB charging — monitor both outlets.',
      icon: Icons.electrical_services_rounded,
      tags: ['Wi-Fi', 'Power Monitoring', '2 Socket'],
      deviceType: DeviceType.socket,
    ),
    _SnarfProduct(
      name: 'USB + Socket',
      desc: 'Smart power socket with built-in USB-A ports and power monitoring.',
      icon: Icons.usb_rounded,
      tags: ['Wi-Fi', 'USB Charging', 'Power Monitor'],
      deviceType: DeviceType.socket,
    ),
  ];

  // ── Fountain & Pool ─────────────────────────────────────────────────────────
  static const _fountain = [
    _SnarfProduct(
      name: 'Fountain Jet Controller',
      desc: 'Start, stop and schedule fountain jets from the app.',
      icon: Icons.water_rounded,
      tags: ['Wi-Fi', 'Tuya', 'Schedule'],
      deviceType: DeviceType.switch_,
    ),
    _SnarfProduct(
      name: 'RGB LED Fountain Light',
      desc: 'Colour scenes that auto-switch at sunset.',
      icon: Icons.light_rounded,
      tags: ['Zigbee', 'RGB', 'Auto-sunset'],
      deviceType: DeviceType.light,
    ),
    _SnarfProduct(
      name: 'Pool Pump Controller',
      desc: 'Remote-control pool pump and heater with scheduling.',
      icon: Icons.pool_rounded,
      tags: ['Wi-Fi', 'Timer', 'Remote'],
      deviceType: DeviceType.switch_,
    ),
  ];



  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    final state = context.watch<AppState>();

    void onAdd(String name, IconData icon, Color color, DeviceType type) =>
        _showAddToHomeSheet(context, state, th, name, icon, color, type);

    return Scaffold(
      backgroundColor: th.screenBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ──────────────────────────────────────────────────────
            SliverToBoxAdapter(child: _buildHero(th)),

            // ── Ecosystem badges ────────────────────────────────────────────
            SliverToBoxAdapter(child: _buildBadges(th)),

            // ── Glass Switches ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _CategorySection(
                title: 'Glass Touch Switches',
                subtitle: 'Upgrade every switch in your home',
                icon: Icons.toggle_on_rounded,
                color: _snarf,
                products: _switches,
                onAdd: onAdd,
                th: th,
              ),
            ),

            // ── Smart Sockets ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _CategorySection(
                title: 'Smart Sockets',
                subtitle: 'Monitor power. Stop waste.',
                icon: Icons.electrical_services_rounded,
                color: const Color(0xFF059669),
                products: _sockets,
                onAdd: onAdd,
                th: th,
              ),
            ),

            // ── Fountain & Pool ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _CategorySection(
                title: 'Fountain & Pool Control',
                subtitle: 'Automate your water features',
                icon: Icons.water_rounded,
                color: const Color(0xFF0EA5E9),
                products: _fountain,
                onAdd: onAdd,
                th: th,
              ),
            ),

            // ── What is SnarF ───────────────────────────────────────────────
            SliverToBoxAdapter(child: _buildWhatIsSnarF(th)),

            // ── Socket detail ────────────────────────────────────────────────
            SliverToBoxAdapter(child: _buildSocketDetail(context, th)),

            // ── Switch detail ────────────────────────────────────────────────
            SliverToBoxAdapter(child: _buildSwitchDetail(context, th)),

            // ── Features strip ──────────────────────────────────────────────
            SliverToBoxAdapter(child: _buildFeatures(th)),

            // ── Installation steps ───────────────────────────────────────────
            SliverToBoxAdapter(child: _buildInstallation(th)),

            // ── Compatibility ─────────────────────────────────────────────────
            SliverToBoxAdapter(child: _buildCompatibility(th)),

            // ── Also by SnarF — Fountain ─────────────────────────────────────
            SliverToBoxAdapter(child: _buildFountainSection(context, th)),

            // ── Contact / Quote ─────────────────────────────────────────────
            SliverToBoxAdapter(child: _buildContact(context, th)),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  // ── Hero ───────────────────────────────────────────────────────────────────
  Widget _buildHero(ThemeHelper th) {
    return Container(
      color: th.topBarBg,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand pill
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _snarf,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'SnarF',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'by NAJOD Systems',
                style: GoogleFonts.inter(
                    fontSize: 12,
                    color: th.textSecondary,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Headline
          Text(
            'Switch Up\nYour Life.',
            style: GoogleFonts.inter(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: th.textPrimary,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 10),

          // Sub-headline
          Text(
            'Smart Switches, Sockets & Fountain Control',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _snarf,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            'Glass touch switches, smart sockets with power monitoring, '
            'dimmer switches, water heater controls, and smart fountain '
            'automation. All Wi-Fi connected, app controlled, and voice activated.',
            style: GoogleFonts.inter(
                fontSize: 13, color: th.textSecondary, height: 1.55),
          ),
        ],
      ),
    );
  }

  // ── Ecosystem badges ───────────────────────────────────────────────────────
  Widget _buildBadges(ThemeHelper th) {
    final badges = [
      (Icons.wifi_rounded, 'Wi-Fi Connected'),
      (Icons.hub_rounded, 'Tuya / Smart Life'),
      (Icons.mic_rounded, 'Amazon Alexa'),
      (Icons.assistant_rounded, 'Google Home'),
      (Icons.bolt_rounded, 'Power Monitoring'),
      (Icons.record_voice_over_rounded, 'Voice Control'),
      (Icons.water_rounded, 'Fountain Control'),
    ];
    return Container(
      color: th.topBarBg,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: badges
            .map((b) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  decoration: BoxDecoration(
                    color: th.chipBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: th.borderColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(b.$1, size: 13, color: _snarf),
                      const SizedBox(width: 5),
                      Text(b.$2,
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: th.textPrimary)),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  // ── Smart Features strip ───────────────────────────────────────────────────
  Widget _buildFeatures(ThemeHelper th) {
    final features = [
      (Icons.phone_iphone_rounded, 'App Control',
          'Control every switch and socket from Tuya / Smart Life — from anywhere.'),
      (Icons.record_voice_over_rounded, 'Voice Control',
          'Works with Amazon Alexa and Google Home for hands-free control.'),
      (Icons.schedule_rounded, 'Schedules & Timers',
          'Set lights on at sunset, water heater at 5 AM. Automate your routines.'),
      (Icons.bolt_rounded, 'Power Monitoring',
          'Sockets track real-time consumption — see exactly what costs you money.'),
      (Icons.auto_awesome_rounded, 'Scene Control',
          '"Movie Mode" dims lights to 30%. "Good Morning" starts the kettle.'),
      (Icons.shield_rounded, 'Overload Protection',
          'Smart sockets detect overloads and cut power automatically.'),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Text('Smart Features',
                style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: th.textPrimary)),
          ),
          ...features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _snarf.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(f.$1, size: 20, color: _snarf),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(f.$2,
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: th.textPrimary)),
                          const SizedBox(height: 2),
                          Text(f.$3,
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: th.textSecondary,
                                  height: 1.4)),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ── What is SnarF ─────────────────────────────────────────────────────────
  Widget _buildWhatIsSnarF(ThemeHelper th) {
    final pills = [
      (Icons.window_rounded,       'Glass Touch',   'Tempered glass,\nblack or white'),
      (Icons.wifi_rounded,         'Wi-Fi',         'No hub required'),
      (Icons.record_voice_over_rounded, 'App + Voice', 'Tuya · Alexa · Google'),
      (Icons.bolt_rounded,         'Power Monitor', 'Real-time on sockets'),
    ];
    return Container(
      color: th.topBarBg,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('What is SnarF?',
              style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _snarf,
                  letterSpacing: 1.2)),
          const SizedBox(height: 8),
          Text('Your entire home\'s electrics — in one app',
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: th.textPrimary,
                  height: 1.2)),
          const SizedBox(height: 10),
          Text(
            'SnarF is NAJOD\'s brand of smart switches and sockets. '
            'We replace your existing wall switches and power outlets with '
            'Wi-Fi connected glass-panel equivalents that you control from '
            'your phone, voice, or schedule.\n\n'
            'Every SnarF device connects to the Tuya / Smart Life ecosystem — '
            'the same app that controls your other NAJOD smart home devices. '
            'One app, everything in one place.',
            style: GoogleFonts.inter(
                fontSize: 13, color: th.textSecondary, height: 1.6),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.6,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: pills.map((p) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _snarf.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _snarf.withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  Icon(p.$1, size: 18, color: _snarf),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(p.$2,
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: th.textPrimary)),
                        Text(p.$3,
                            style: GoogleFonts.inter(
                                fontSize: 10,
                                color: th.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  // ── Smart Sockets detail ───────────────────────────────────────────────────
  Widget _buildSocketDetail(BuildContext context, ThemeHelper th) {
    final bullets = [
      'Single and double gang options in black glass',
      'USB-A charging ports built in on select models',
      'Real-time wattage and energy tracking in the app',
      'Remote on/off from anywhere in the world',
      'Schedule sockets to turn off overnight automatically',
      'Overload alerts before damage occurs',
    ];
    return _DetailSection(
      th: th,
      icon: Icons.electrical_services_rounded,
      iconColor: const Color(0xFF059669),
      title: 'Smart Sockets',
      subtitle: 'Monitor power. Stop waste.',
      body: 'SnarF sockets are more than just plug points. Each one monitors '
          'real-time power consumption so you can see exactly which appliance '
          'is drawing electricity — and switch it off remotely if you left it on by mistake.',
      bullets: bullets,
      ctaLabel: 'Enquire About Sockets',
      onCta: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Opening WhatsApp for socket enquiry…',
            style: GoogleFonts.inter()),
        backgroundColor: const Color(0xFF25D366),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      )),
    );
  }

  // ── Glass Touch Switches detail ────────────────────────────────────────────
  Widget _buildSwitchDetail(BuildContext context, ThemeHelper th) {
    final bullets = [
      '1-Gang, 2-Gang, and 3-Gang options',
      'Tempered glass in black or white finish',
      'Dimming switch for ambient lighting control',
      'Water heater switch with timer scheduling',
      'Works with existing wiring — no rewiring needed',
      'Voice control via Alexa and Google Home',
    ];
    return _DetailSection(
      th: th,
      icon: Icons.toggle_on_rounded,
      iconColor: _snarf,
      title: 'Glass Touch Switches',
      subtitle: 'Upgrade every switch in your home.',
      body: 'SnarF glass touch switches replace your existing rocker switches '
          'with premium tempered-glass panels. Available in 1, 2, and 3 gang '
          'versions in black or white — they look premium and work smarter.',
      bullets: bullets,
      ctaLabel: 'Enquire About Switches',
      onCta: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Opening WhatsApp for switch enquiry…',
            style: GoogleFonts.inter()),
        backgroundColor: const Color(0xFF25D366),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      )),
    );
  }

  // ── Installation steps ─────────────────────────────────────────────────────
  Widget _buildInstallation(ThemeHelper th) {
    final steps = [
      ('01', 'Assessment',
          'We assess your home or office and recommend the right switch and socket configuration for each room.'),
      ('02', 'Installation',
          'Our certified electricians replace your existing fittings with SnarF smart devices. Usually completed in one visit.'),
      ('03', 'App Setup',
          'We connect every device to your Tuya / Smart Life app, configure schedules, scenes, and voice control.'),
      ('04', 'You\'re in Control',
          'Turn off every light in the house from your bed. Set the water heater to come on at 5 AM. Your house, your rules.'),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Installation',
              style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _snarf,
                  letterSpacing: 1.2)),
          const SizedBox(height: 6),
          Text('Up and running in hours',
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: th.textPrimary)),
          const SizedBox(height: 16),
          ...steps.asMap().entries.map((entry) {
            final i = entry.key;
            final s = entry.value;
            final isLast = i == steps.length - 1;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _snarf,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(s.$1,
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.white)),
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 40,
                        color: _snarf.withValues(alpha: 0.2),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.$2,
                            style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: th.textPrimary)),
                        const SizedBox(height: 4),
                        Text(s.$3,
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                color: th.textSecondary,
                                height: 1.5)),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ── Compatibility ──────────────────────────────────────────────────────────
  Widget _buildCompatibility(ThemeHelper th) {
    final items = [
      (Icons.phone_iphone_rounded,  'Tuya / Smart Life', 'Primary control app',  AppColors.primary),
      (Icons.mic_rounded,           'Amazon Alexa',      'Voice control',         const Color(0xFF00A6FF)),
      (Icons.assistant_rounded,     'Google Home',       'Voice & routines',      const Color(0xFF34A853)),
      (Icons.hub_rounded,           'NAJOD Ecosystem',   'Integrates with all\nNAJOD devices', _snarf),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Compatibility',
              style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _snarf,
                  letterSpacing: 1.2)),
          const SizedBox(height: 6),
          Text('Works with everything you already use',
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: th.textPrimary)),
          const SizedBox(height: 8),
          Text(
            'SnarF devices are part of the Tuya ecosystem — meaning they work '
            'alongside your existing NAJOD smart home devices, cameras, sensors, '
            'and control panels. One app controls your entire property.',
            style: GoogleFonts.inter(
                fontSize: 13, color: th.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: items.map((item) => Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: th.cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: th.borderColor),
                boxShadow: th.cardShadow,
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: item.$4.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item.$1, size: 18, color: item.$4),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item.$2,
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: th.textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        Text(item.$3,
                            style: GoogleFonts.inter(
                                fontSize: 10,
                                color: th.textSecondary),
                            maxLines: 2),
                      ],
                    ),
                  ),
                ],
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  // ── Also by SnarF — Fountain & Pool ───────────────────────────────────────
  Widget _buildFountainSection(BuildContext context, ThemeHelper th) {
    const fountainColor = Color(0xFF0EA5E9);
    final bullets = [
      'Fountain jet control — start, stop, schedule from the app',
      'RGB LED colour scenes — auto-switch at sunset',
      'Pool pump and heater remote control',
      'Water level sensors with instant alerts',
      'Works alongside your SnarF switches in one app',
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Container(
        decoration: BoxDecoration(
          color: th.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: fountainColor.withValues(alpha: 0.25)),
          boxShadow: th.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header band
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              decoration: BoxDecoration(
                color: fountainColor.withValues(alpha: 0.08),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: fountainColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.water_rounded,
                        color: fountainColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Also by SnarF',
                            style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: fountainColor,
                                letterSpacing: 1.1)),
                        Text('Smart Fountain & Pool Control',
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: th.textPrimary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SnarF extends beyond wall switches — we also automate '
                    'fountains, pools, and water features using the same '
                    'Tuya / Zigbee ecosystem. Control jets, RGB LED lighting, '
                    'pump schedules, and safety sensors from the same app.',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        color: th.textSecondary,
                        height: 1.55),
                  ),
                  const SizedBox(height: 14),
                  ...bullets.map((b) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: fountainColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(b,
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: th.textPrimary,
                                      height: 1.4)),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Opening WhatsApp for fountain control enquiry…',
                            style: GoogleFonts.inter()),
                        backgroundColor: const Color(0xFF25D366),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        duration: const Duration(seconds: 2),
                      )),
                      icon: const Icon(Icons.chat_rounded, size: 18),
                      label: Text('Enquire About Fountain Control',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: fountainColor,
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Contact / Quote ────────────────────────────────────────────────────────
  Widget _buildContact(BuildContext context, ThemeHelper th) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_snarf, _snarfDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ready to switch up your life?',
                style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
            const SizedBox(height: 6),
            Text(
              'Get a free quote for SnarF smart switches and sockets fitted '
              'in your home or office. Professional installation included.',
              style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.5),
            ),
            const SizedBox(height: 20),

            // WhatsApp CTA
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(children: [
                      const Icon(Icons.chat_rounded,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text('Opening WhatsApp…',
                          style: GoogleFonts.inter()),
                    ]),
                    backgroundColor: const Color(0xFF25D366),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.chat_rounded,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text('Get a Free Quote on WhatsApp',
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Call CTA
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(children: [
                      const Icon(Icons.phone_rounded,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text('Call +256 756 150 925',
                          style: GoogleFonts.inter()),
                    ]),
                    backgroundColor: _snarf,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.phone_rounded,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text('Call +256 756 150 925',
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),
            Center(
              child: Text(
                'Mengo, Hamu Mukasa Rd, Kampala · inquiries@najod.co',
                style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.65)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Add to Home sheet ──────────────────────────────────────────────────────
  void _showAddToHomeSheet(
    BuildContext context,
    AppState state,
    ThemeHelper th,
    String productName,
    IconData icon,
    Color color,
    DeviceType type,
  ) {
    final nameCtrl = TextEditingController(text: productName);
    String? selectedRoom;

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
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: th.divider,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: color, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Add to Home',
                              style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: th.textPrimary)),
                          Text('SnarF · $productName',
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: th.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Text('Device name',
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
                    hintText: 'e.g. Living Room Switch',
                    hintStyle: GoogleFonts.inter(color: th.textHint),
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
                const SizedBox(height: 20),

                Text('Add to room',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: th.textSecondary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: state.rooms
                      .where((r) => r.id != 'all')
                      .map((r) {
                    final isSel = selectedRoom == r.name;
                    return GestureDetector(
                      onTap: () => setSheet(() => selectedRoom = r.name),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSel
                              ? _snarf.withValues(alpha: 0.12)
                              : th.chipBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSel ? _snarf : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Text(r.name,
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isSel ? _snarf : th.textSecondary)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final name = nameCtrl.text.trim();
                      if (name.isEmpty || selectedRoom == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please name the device and pick a room',
                              style: GoogleFonts.inter()),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ));
                        return;
                      }
                      state.addDevice(Device(
                        id: 'snarf_${DateTime.now().millisecondsSinceEpoch}',
                        name: name,
                        room: selectedRoom!,
                        type: type,
                        status: DeviceStatus.online,
                        protocol: ProtocolType.wifi,
                        isOn: false,
                        icon: icon,
                        iconColor: color,
                      ));
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(children: [
                          const Icon(Icons.check_circle_rounded,
                              color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text('"$name" added to $selectedRoom',
                              style: GoogleFonts.inter()),
                        ]),
                        backgroundColor: AppColors.active,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        duration: const Duration(seconds: 2),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _snarf,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text('Add to Home',
                        style: GoogleFonts.inter(
                            fontSize: 15, fontWeight: FontWeight.w700)),
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

// ─── Product data model ────────────────────────────────────────────────────────
class _SnarfProduct {
  final String name;
  final String desc;
  final IconData icon;
  final List<String> tags;
  final DeviceType deviceType;

  const _SnarfProduct({
    required this.name,
    required this.desc,
    required this.icon,
    required this.tags,
    required this.deviceType,
  });
}

// ─── Category section ──────────────────────────────────────────────────────────
class _CategorySection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<_SnarfProduct> products;
  final void Function(String, IconData, Color, DeviceType) onAdd;
  final ThemeHelper th;

  const _CategorySection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.products,
    required this.onAdd,
    required this.th,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: th.textPrimary)),
                    Text(subtitle,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: th.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Product cards
          ...products.map((p) => _ProductCard(
                product: p,
                categoryColor: color,
                onAdd: () => onAdd(p.name, p.icon, color, p.deviceType),
                th: th,
              )),
        ],
      ),
    );
  }
}

// ─── Single product card ───────────────────────────────────────────────────────
class _ProductCard extends StatelessWidget {
  final _SnarfProduct product;
  final Color categoryColor;
  final VoidCallback onAdd;
  final ThemeHelper th;

  const _ProductCard({
    required this.product,
    required this.categoryColor,
    required this.onAdd,
    required this.th,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: th.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: th.borderColor),
        boxShadow: th.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(product.icon, color: categoryColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: th.textPrimary)),
                const SizedBox(height: 3),
                Text(product.desc,
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        color: th.textSecondary,
                        height: 1.35)),
                const SizedBox(height: 6),
                // Tags
                Wrap(
                  spacing: 5,
                  runSpacing: 4,
                  children: product.tags
                      .map((tag) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: categoryColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(tag,
                                style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: categoryColor)),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(
              backgroundColor: _snarf,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: Text('Add',
                style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}



// ─── Reusable detail section (Sockets / Switches) ─────────────────────────────
class _DetailSection extends StatelessWidget {
  final ThemeHelper th;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String body;
  final List<String> bullets;
  final String ctaLabel;
  final VoidCallback onCta;

  const _DetailSection({
    required this.th,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.bullets,
    required this.ctaLabel,
    required this.onCta,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: th.textPrimary)),
                    Text(subtitle,
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            color: iconColor,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(body,
              style: GoogleFonts.inter(
                  fontSize: 13, color: th.textSecondary, height: 1.55)),
          const SizedBox(height: 14),
          ...bullets.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: iconColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(b,
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              color: th.textPrimary,
                              height: 1.4)),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onCta,
              icon: Icon(Icons.chat_rounded, size: 16, color: iconColor),
              label: Text(ctaLabel,
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: iconColor)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: iconColor, width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

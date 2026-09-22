import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/theme_helper.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  static final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Control & Audio',
      'icon': Icons.tablet_android_rounded,
      'color': AppColors.accentBlue,
      'desc': 'Android panels, gateways, multi-zone music hosts',
      'products': ['Android Central Panel 10"', 'Zigbee Gateway Hub', 'Multi-zone Music Host 4-zone', 'Smart Speaker Gateway'],
    },
    {
      'title': 'Video Intercom & Locks',
      'icon': Icons.videocam_rounded,
      'color': AppColors.accentRed,
      'desc': '5–10" IP65 door stations, face & fingerprint locks',
      'products': ['Video Door Station 7" IP65', 'Face Recognition Lock', 'Fingerprint Smart Lock', '10" Door Panel IP65'],
    },
    {
      'title': 'Glass Switches',
      'icon': Icons.toggle_on_rounded,
      'color': AppColors.accentPurple,
      'desc': 'EU & US touch-glass, Wi-Fi or Zigbee, 1–4 gang',
      'products': ['EU 1-Gang Glass Switch Wi-Fi', 'EU 2-Gang Glass Switch Zigbee', 'US 3-Gang Glass Switch Wi-Fi', 'EU 4-Gang Glass Switch (Black)'],
    },
    {
      'title': 'Sockets & Outlets',
      'icon': Icons.electrical_services_rounded,
      'color': AppColors.accentYellow,
      'desc': 'Universal, Schuko, UK, French, USB / Type-C outlets',
      'products': ['Universal Smart Socket', 'Schuko Power Meter Socket', 'UK 3-Pin Smart Outlet', 'USB + Type-C Charging Socket'],
    },
    {
      'title': 'Sensors & Safety',
      'icon': Icons.sensors_rounded,
      'color': AppColors.accentGreen,
      'desc': 'Presence, door, water-leak, gas, smoke & thermostats',
      'products': ['Presence Sensor Zigbee', 'Door / Window Sensor', 'Water Leak Detector', 'Gas Sensor Zigbee', 'Smoke Detector', 'AC Thermostat Wi-Fi'],
    },
    {
      'title': 'Modules & Relays',
      'icon': Icons.developer_board_rounded,
      'color': AppColors.accentCyan,
      'desc': 'Mini in-wall modules, dimmers, aluminium scene switches',
      'products': ['Mini In-wall Module 1-gang', 'In-wall Dimmer Module', 'Aluminium Scene Switch 4-gang', '2-gang Relay Module Zigbee'],
    },
    {
      'title': 'Smart Curtains',
      'icon': Icons.blinds_rounded,
      'color': AppColors.accentOrange,
      'desc': 'Zigbee tubular motors, tracks, remotes & gateways',
      'products': ['Zigbee Tubular Motor 45 Nm', 'Curtain Track 4 m', 'Wireless Remote 4-channel', 'Wired Curtain Gateway'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    return Scaffold(
      backgroundColor: th.screenBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(th)),
            SliverToBoxAdapter(child: _buildEcosystemBadges(th)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _CategoryCard(category: _categories[i]),
                  childCount: _categories.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeHelper th) {
    return Container(
      color: th.topBarBg,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'THE RANGE',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'One ecosystem\nfor the whole home',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: th.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Every smart product speaks the same language — Tuya / Smart Life, Zigbee 3.0, MQTT and Wi-Fi — so panels, switches, sensors and motors work together out of the box.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: th.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEcosystemBadges(ThemeHelper th) {
    final partners = [
      {'label': 'Tuya',       'icon': Icons.hub_rounded},
      {'label': 'Smart Life', 'icon': Icons.phone_iphone_rounded},
      {'label': 'Alexa',      'icon': Icons.mic_rounded},
      {'label': 'Google',     'icon': Icons.assistant_rounded},
      {'label': 'Zigbee',     'icon': Icons.radar_rounded},
      {'label': 'MQTT',       'icon': Icons.wifi_rounded},
    ];

    return Container(
      color: th.topBarBg,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Works With',
              style: GoogleFonts.inter(
                  fontSize: 13,
                  color: th.textSecondary,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: partners
                .map((p) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: th.chipBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(p['icon'] as IconData,
                              size: 14, color: AppColors.primary),
                          const SizedBox(width: 5),
                          Text(
                            p['label'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: th.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final Map<String, dynamic> category;

  const _CategoryCard({required this.category});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    final cat = widget.category;
    final color = cat['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: th.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: th.cardShadow,
        border: Border.all(color: th.borderColor),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(cat['icon'] as IconData, color: color, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cat['title'] as String,
                          style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: th.textPrimary),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          cat['desc'] as String,
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              color: th.textSecondary,
                              height: 1.3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        color: th.textHint),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                Divider(height: 1, color: th.divider),
                const SizedBox(height: 8),
                ...(cat['products'] as List<String>).map(
                  (p) => ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    dense: true,
                    leading: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(cat['icon'] as IconData,
                          color: color, size: 16),
                    ),
                    title: Text(p,
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: th.textPrimary)),
                    trailing: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 28),
                      ),
                      child: Text('Add',
                          style: GoogleFonts.inter(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/theme_helper.dart';

class EnergyScreen extends StatelessWidget {
  const EnergyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final th = ThemeHelper.of(context);

    return Scaffold(
      backgroundColor: th.screenBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildTopBar(th)),
            SliverToBoxAdapter(child: _buildHeroCard(state)),
            SliverToBoxAdapter(child: _buildChart(state, th)),
            SliverToBoxAdapter(child: _buildAIFeaturesBanner(th)),
            SliverToBoxAdapter(child: _buildConsumptionDetails(th)),
            SliverToBoxAdapter(child: _buildDeviceBreakdown(th)),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(ThemeHelper th) {
    return Container(
      color: th.topBarBg,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'AI Energy Saving',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: th.textPrimary,
            ),
          ),
          Row(
            children: [
              _iconBtn(Icons.more_horiz_rounded, th),
              const SizedBox(width: 8),
              _iconBtn(Icons.close_rounded, th),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, ThemeHelper th) => Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: th.chipBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: th.iconSecondary),
      );

  Widget _buildHeroCard(AppState state) {
    // Hero card stays gradient — always looks fine in both modes
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.energyGradient,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This week',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          state.totalEnergy.toStringAsFixed(1),
                          style: GoogleFonts.inter(
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'kWh',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text('Saved',
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.7))),
                      Text('8.00',
                          style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      Text('kWh',
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.7))),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _PeriodBtn(
                    label: 'Week',
                    isSelected: state.energyWeekView,
                    onTap: () => state.toggleEnergyView(true)),
                const SizedBox(width: 8),
                _PeriodBtn(
                    label: 'Month',
                    isSelected: !state.energyWeekView,
                    onTap: () => state.toggleEnergyView(false)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(AppState state, ThemeHelper th) {
    final data = state.energyData;
    final labels = state.energyWeekView
        ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        : List.generate(data.length, (i) => '${i + 1}');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: th.cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: th.cardShadow,
          border: Border.all(color: th.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Consumption Chart',
                    style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: th.textPrimary)),
                Row(
                  children: [
                    _LegendDot(color: AppColors.primary, label: 'kWh', th: th),
                    const SizedBox(width: 12),
                    _LegendDot(
                        color: AppColors.active.withValues(alpha: 0.4),
                        label: 'Saved',
                        th: th),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (data.reduce((a, b) => a > b ? a : b) * 1.3),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: th.isDark
                          ? AppColors.bgCardLight
                          : AppColors.bgCard,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.toStringAsFixed(1)} kWh',
                          GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx >= labels.length) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(labels[idx],
                                style: GoogleFonts.inter(
                                    fontSize: 11, color: th.textHint)),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) => Text(
                          value.toStringAsFixed(0),
                          style: GoogleFonts.inter(
                              fontSize: 10, color: th.textHint),
                        ),
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: th.divider,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: data.asMap().entries.map((e) {
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value,
                          gradient: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [AppColors.primary, Color(0xFF60A5FA)],
                          ),
                          width: 16,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(6)),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIFeaturesBanner(ThemeHelper th) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: th.bannerBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: th.bannerBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.auto_awesome_rounded,
                  color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Discover more advanced features',
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: th.textPrimary)),
                  Text('AI recommendations to reduce consumption',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: th.textSecondary)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Learn more',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsumptionDetails(ThemeHelper th) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Energy consumption details',
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: th.textPrimary)),
          const SizedBox(height: 12),
          Row(
            children: [
              _DetailTabChip(label: 'Week', isSelected: true, th: th),
              const SizedBox(width: 8),
              _DetailTabChip(label: 'Month', isSelected: false, th: th),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 80,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: th.cardBg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: th.cardShadow,
              border: Border.all(color: th.borderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('30 kW',
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary)),
                      Text('Peak usage',
                          style: GoogleFonts.inter(
                              fontSize: 11, color: th.textHint)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('20 kW',
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accentGreen)),
                      Text('Off-peak',
                          style: GoogleFonts.inter(
                              fontSize: 11, color: th.textHint)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceBreakdown(ThemeHelper th) {
    final deviceUsage = [
      {'name': 'Air Conditioner', 'kwh': 28.4, 'pct': 0.52, 'color': AppColors.accentBlue},
      {'name': 'Lighting',        'kwh': 12.1, 'pct': 0.22, 'color': AppColors.accentYellow},
      {'name': 'Sockets',         'kwh': 8.7,  'pct': 0.16, 'color': AppColors.accentOrange},
      {'name': 'Other',           'kwh': 5.2,  'pct': 0.10, 'color': AppColors.textHint},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: th.cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: th.cardShadow,
          border: Border.all(color: th.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Device Breakdown',
                style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: th.textPrimary)),
            const SizedBox(height: 16),
            ...deviceUsage.map((d) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(d['name'] as String,
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: th.textPrimary)),
                          Text(
                            '${(d['kwh'] as double).toStringAsFixed(1)} kWh',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: d['color'] as Color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: d['pct'] as double,
                          backgroundColor: th.progressTrack,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              d['color'] as Color),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _PeriodBtn extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodBtn(
      {required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? AppColors.accentGreen
                : Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final ThemeHelper th;

  const _LegendDot(
      {required this.color, required this.label, required this.th});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label,
            style: GoogleFonts.inter(fontSize: 11, color: th.textHint)),
      ],
    );
  }
}

class _DetailTabChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ThemeHelper th;

  const _DetailTabChip(
      {required this.label, required this.isSelected, required this.th});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : th.chipBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : th.textSecondary,
        ),
      ),
    );
  }
}

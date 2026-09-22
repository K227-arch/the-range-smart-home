import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/device.dart';
import '../theme/app_colors.dart';
import '../theme/theme_helper.dart';

class DeviceDetailScreen extends StatefulWidget {
  final Device device;

  const DeviceDetailScreen({super.key, required this.device});

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  late bool _isOn;
  double _brightness = 80;
  double _temperature = 22;
  double _curtainPosition = 50;

  // Schedule entries: {time, label, days}
  final List<Map<String, String>> _schedules = [
    {'time': '07:00', 'label': 'Turn On',  'days': 'Mon–Fri'},
    {'time': '22:30', 'label': 'Turn Off', 'days': 'Every day'},
  ];

  @override
  void initState() {
    super.initState();
    _isOn = widget.device.isOn;
    if (widget.device.attributes.containsKey('brightness')) {
      _brightness = (widget.device.attributes['brightness'] as int).toDouble();
    }
    if (widget.device.attributes.containsKey('temp')) {
      _temperature = (widget.device.attributes['temp'] as int).toDouble();
    }
    if (widget.device.attributes.containsKey('position')) {
      _curtainPosition =
          (widget.device.attributes['position'] as int).toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);

    return Scaffold(
      backgroundColor: th.screenBg,
      appBar: AppBar(
        backgroundColor: th.topBarBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: th.iconPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.device.name,
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: th.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz_rounded, color: th.iconSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeroCard(),
            const SizedBox(height: 20),
            _buildControls(th),
            const SizedBox(height: 20),
            _buildInfoCard(th),
            const SizedBox(height: 20),
            _buildScheduleCard(th),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    // Hero is always gradient — works in both modes
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: _isOn
            ? AppColors.primaryGradient
            : const LinearGradient(
                colors: [Color(0xFF64748B), Color(0xFF475569)]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(widget.device.icon,
              size: 64,
              color: Colors.white.withValues(alpha: _isOn ? 1 : 0.5)),
          const SizedBox(height: 16),
          Text(widget.device.name,
              style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 4),
          Text(widget.device.room,
              style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.7))),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => setState(() => _isOn = !_isOn),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: _isOn ? 0.25 : 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5), width: 2),
              ),
              child: const Icon(Icons.power_settings_new_rounded,
                  color: Colors.white, size: 28),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isOn ? 'ON' : 'OFF',
            style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.9)),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(ThemeHelper th) {
    switch (widget.device.type) {
      case DeviceType.light:
        return _buildLightControls(th);
      case DeviceType.thermostat:
      case DeviceType.airConditioner:
        return _buildThermostatControls(th);
      case DeviceType.curtain:
        return _buildCurtainControls(th);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLightControls(ThemeHelper th) {
    return _card(
      th,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Brightness',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: th.textPrimary)),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.brightness_low_rounded, color: th.textHint),
              Expanded(
                child: Slider(
                  value: _brightness,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  activeColor: AppColors.primary,
                  inactiveColor: th.progressTrack,
                  onChanged: (v) => setState(() => _brightness = v),
                ),
              ),
              const Icon(Icons.brightness_high_rounded,
                  color: AppColors.accentYellow),
            ],
          ),
          Center(
            child: Text(
              '${_brightness.round()}%',
              style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 16),
          Text('Color Temperature',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: th.textPrimary)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _TempButton(label: 'Warm', temp: 2700, th: th),
              _TempButton(label: 'Neutral', temp: 4000, th: th),
              _TempButton(label: 'Cool', temp: 6500, th: th),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThermostatControls(ThemeHelper th) {
    return _card(
      th,
      Column(
        children: [
          Text('Temperature',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: th.textPrimary)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => setState(
                    () => _temperature = (_temperature - 0.5).clamp(16, 30)),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                      color: th.chipBg,
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.remove_rounded, color: th.iconPrimary),
                ),
              ),
              const SizedBox(width: 24),
              Column(
                children: [
                  Text(
                    _temperature.toStringAsFixed(1),
                    style: GoogleFonts.inter(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary),
                  ),
                  Text('°C',
                      style: GoogleFonts.inter(
                          fontSize: 18, color: th.textSecondary)),
                ],
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: () => setState(
                    () => _temperature = (_temperature + 0.5).clamp(16, 30)),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add_rounded, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ModeButton(
                  label: 'Cool',
                  icon: Icons.ac_unit_rounded,
                  isSelected: true,
                  th: th),
              _ModeButton(
                  label: 'Heat',
                  icon: Icons.local_fire_department_rounded,
                  isSelected: false,
                  th: th),
              _ModeButton(
                  label: 'Fan',
                  icon: Icons.air_rounded,
                  isSelected: false,
                  th: th),
              _ModeButton(
                  label: 'Auto',
                  icon: Icons.autorenew_rounded,
                  isSelected: false,
                  th: th),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurtainControls(ThemeHelper th) {
    return _card(
      th,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Curtain Position',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: th.textPrimary)),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 8,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              activeTrackColor: AppColors.accentOrange,
              inactiveTrackColor: th.progressTrack,
              thumbColor: AppColors.accentOrange,
            ),
            child: Slider(
              value: _curtainPosition,
              min: 0,
              max: 100,
              onChanged: (v) => setState(() => _curtainPosition = v),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Closed',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: th.textHint)),
              Text('${_curtainPosition.round()}%',
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentOrange)),
              Text('Open',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: th.textHint)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => setState(() => _curtainPosition = 0),
                icon: const Icon(Icons.vertical_align_top_rounded, size: 16),
                label: const Text('Close'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: th.chipBg,
                  foregroundColor: th.textPrimary,
                  elevation: 0,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => setState(() => _curtainPosition = 50),
                icon: const Icon(Icons.linear_scale_rounded, size: 16),
                label: const Text('Half'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.accentOrange.withValues(alpha: 0.1),
                  foregroundColor: AppColors.accentOrange,
                  elevation: 0,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => setState(() => _curtainPosition = 100),
                icon: const Icon(Icons.vertical_align_bottom_rounded,
                    size: 16),
                label: const Text('Open'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(ThemeHelper th) {
    return _card(
      th,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Device Info',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: th.textPrimary)),
          const SizedBox(height: 12),
          _InfoRow(label: 'Room', value: widget.device.room, th: th),
          _InfoRow(
              label: 'Protocol',
              value: widget.device.protocol.name.toUpperCase(),
              th: th),
          _InfoRow(label: 'Status', value: 'Online', th: th),
          _InfoRow(
              label: 'Device ID',
              value: widget.device.id.toUpperCase(),
              th: th),
          _InfoRow(
              label: 'Ecosystem', value: 'Tuya / Smart Life', th: th),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(ThemeHelper th) {
    return _card(
      th,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Schedule',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: th.textPrimary)),
              TextButton.icon(
                onPressed: () => _showAddScheduleSheet(context, th),
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Add'),
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: EdgeInsets.zero),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._schedules.map((s) => _ScheduleRow(
                time: s['time']!,
                label: s['label']!,
                days: s['days']!,
                th: th,
              )),
        ],
      ),
    );
  }

  void _showAddScheduleSheet(BuildContext context, ThemeHelper th) {
    // Defaults
    TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);
    String selectedAction = 'Turn On';
    final List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final Set<String> selectedDays = {'Mon', 'Tue', 'Wed', 'Thu', 'Fri'};

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
                Text('Add Schedule',
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: th.textPrimary)),
                const SizedBox(height: 4),
                Text('Pick a time, action and repeat days',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: th.textSecondary)),
                const SizedBox(height: 24),

                // Time picker row
                Text('Time',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: th.textSecondary)),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: ctx,
                      initialTime: selectedTime,
                      builder: (c, child) => Theme(
                        data: Theme.of(c).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColors.primary,
                            surface: th.cardBg,
                            onSurface: th.textPrimary,
                          ),
                          dialogTheme: DialogThemeData(
                              backgroundColor: th.cardBg),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) {
                      setSheet(() => selectedTime = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primary
                              .withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.schedule_rounded,
                            color: AppColors.primary, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          selectedTime.format(ctx),
                          style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary),
                        ),
                        const Spacer(),
                        Text('Tap to change',
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                color: th.textSecondary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Action
                Text('Action',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: th.textSecondary)),
                const SizedBox(height: 10),
                Row(
                  children: ['Turn On', 'Turn Off'].map((action) {
                    final isSel = selectedAction == action;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setSheet(() => selectedAction = action),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          margin: EdgeInsets.only(
                              right: action == 'Turn On' ? 8 : 0),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12),
                          decoration: BoxDecoration(
                            color: isSel
                                ? AppColors.primary
                                    .withValues(alpha: 0.12)
                                : th.chipBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSel
                                  ? AppColors.primary
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(action,
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isSel
                                        ? AppColors.primary
                                        : th.textSecondary)),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Repeat days
                Text('Repeat',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: th.textSecondary)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: weekDays.map((day) {
                    final isSel = selectedDays.contains(day);
                    return GestureDetector(
                      onTap: () => setSheet(() {
                        if (isSel) {
                          selectedDays.remove(day);
                        } else {
                          selectedDays.add(day);
                        }
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: isSel
                              ? AppColors.primary
                              : th.chipBg,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSel
                                ? AppColors.primary
                                : Colors.transparent,
                          ),
                        ),
                        child: Center(
                          child: Text(day.substring(0, 1),
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isSel
                                      ? Colors.white
                                      : th.textSecondary)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 28),

                // Save
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedDays.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Select at least one day',
                                style: GoogleFonts.inter()),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12)),
                          ),
                        );
                        return;
                      }
                      // Build days label
                      String daysLabel;
                      if (selectedDays.length == 7) {
                        daysLabel = 'Every day';
                      } else if (selectedDays.containsAll(
                              ['Mon', 'Tue', 'Wed', 'Thu', 'Fri']) &&
                          selectedDays.length == 5) {
                        daysLabel = 'Mon–Fri';
                      } else {
                        final order = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
                        daysLabel = order
                            .where((d) => selectedDays.contains(d))
                            .join(', ');
                      }
                      final h =
                          selectedTime.hour.toString().padLeft(2, '0');
                      final m =
                          selectedTime.minute.toString().padLeft(2, '0');
                      setState(() => _schedules.add({
                            'time': '$h:$m',
                            'label': selectedAction,
                            'days': daysLabel,
                          }));
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(children: [
                            const Icon(Icons.check_circle_rounded,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(
                                'Schedule added: $h:$m · $selectedAction',
                                style: GoogleFonts.inter()),
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
                    child: Text('Save Schedule',
                        style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Shared card container
  Widget _card(ThemeHelper th, Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: th.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: th.cardShadow,
        border: Border.all(color: th.borderColor),
      ),
      child: child,
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _TempButton extends StatelessWidget {
  final String label;
  final int temp;
  final ThemeHelper th;

  const _TempButton(
      {required this.label, required this.temp, required this.th});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: th.chipBg, borderRadius: BorderRadius.circular(10)),
      child: Text(label,
          style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: th.textPrimary)),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final ThemeHelper th;

  const _ModeButton(
      {required this.label,
      required this.icon,
      required this.isSelected,
      required this.th});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.1)
            : th.chipBg,
        borderRadius: BorderRadius.circular(10),
        border: isSelected
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 14,
              color: isSelected ? AppColors.primary : th.textHint),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColors.primary : th.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final ThemeHelper th;

  const _InfoRow(
      {required this.label, required this.value, required this.th});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 13, color: th.textSecondary)),
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: th.textPrimary)),
        ],
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  final String time;
  final String label;
  final String days;
  final ThemeHelper th;

  const _ScheduleRow(
      {required this.time,
      required this.label,
      required this.days,
      required this.th});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.schedule_rounded,
                color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: th.textPrimary)),
                Text(days,
                    style: GoogleFonts.inter(
                        fontSize: 12, color: th.textSecondary)),
              ],
            ),
          ),
          Text(time,
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary)),
        ],
      ),
    );
  }
}

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
  late bool _isOnline;
  double _brightness = 80;
  double _temperature = 22;
  double _curtainPosition = 50;
  late double _liveWatts;

  // Finish selector (Glass Touch switches & sockets — black or white)
  String _finish = 'Black';

  // Sunset auto-mode (fountain / RGB light devices)
  bool _sunsetAuto = false;

  final List<Map<String, String>> _schedules = [
    {'time': '07:00', 'label': 'Turn On', 'days': 'Mon–Fri'},
    {'time': '22:30', 'label': 'Turn Off', 'days': 'Every day'},
  ];

  @override
  void initState() {
    super.initState();
    _isOn = widget.device.isOn;
    _isOnline = widget.device.status == DeviceStatus.online;
    _liveWatts = widget.device.powerWatts ?? 0.0;
    if (widget.device.attributes.containsKey('brightness')) {
      _brightness =
          (widget.device.attributes['brightness'] as int).toDouble();
    }
    if (widget.device.attributes.containsKey('temp')) {
      _temperature =
          (widget.device.attributes['temp'] as int).toDouble();
    }
    if (widget.device.attributes.containsKey('position')) {
      _curtainPosition =
          (widget.device.attributes['position'] as int).toDouble();
    }
  }

  // ── Connectivity label derived from FAQ ──────────────────────────────────
  String get _protocolLabel {
    switch (widget.device.protocol) {
      case ProtocolType.wifi:
        return 'Wi-Fi Direct (No Hub)';
      case ProtocolType.zigbee:
        return 'Zigbee 3.0';
      case ProtocolType.bluetooth:
        return 'Bluetooth';
    }
  }

  String get _installLabel {
    switch (widget.device.installationStatus) {
      case InstallationStatus.installed:
        return 'Installed by NAJOD';
      case InstallationStatus.scheduled:
        return 'Installation Scheduled';
      case InstallationStatus.notInstalled:
        return 'Self-installed';
    }
  }

  Color _installColor(ThemeHelper th) {
    switch (widget.device.installationStatus) {
      case InstallationStatus.installed:
        return AppColors.active;
      case InstallationStatus.scheduled:
        return AppColors.accentYellow;
      case InstallationStatus.notInstalled:
        return th.textSecondary;
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
        title: Text(widget.device.name,
            style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: th.textPrimary)),
        actions: [
          // Remote access indicator in app bar
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Tooltip(
              message: widget.device.remoteAccess
                  ? 'Remote access active — control from anywhere'
                  : 'Remote access unavailable — check Wi-Fi',
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.device.remoteAccess
                      ? AppColors.active.withValues(alpha: 0.1)
                      : AppColors.accentRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.device.remoteAccess
                          ? Icons.public_rounded
                          : Icons.public_off_rounded,
                      size: 13,
                      color: widget.device.remoteAccess
                          ? AppColors.active
                          : AppColors.accentRed,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.device.remoteAccess ? 'Remote' : 'Local only',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: widget.device.remoteAccess
                              ? AppColors.active
                              : AppColors.accentRed),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeroCard(th),
            const SizedBox(height: 16),
            // Power monitoring card — sockets only
            if (widget.device.type == DeviceType.socket)
              _buildPowerCard(th),
            if (widget.device.type == DeviceType.socket)
              const SizedBox(height: 16),
            _buildControls(th),
            if (widget.device.type != DeviceType.switch_ &&
                widget.device.type != DeviceType.socket)
              const SizedBox(height: 16),
            const SizedBox(height: 16),
            _buildConnectivityCard(th),
            const SizedBox(height: 16),
            // Finish selector — switches & sockets only
            if (widget.device.type == DeviceType.switch_ ||
                widget.device.type == DeviceType.socket)
              _buildFinishSelector(th),
            if (widget.device.type == DeviceType.switch_ ||
                widget.device.type == DeviceType.socket)
              const SizedBox(height: 16),
            // Sunset auto-mode — fountain / RGB light
            if (widget.device.type == DeviceType.light &&
                (widget.device.icon == Icons.water_rounded ||
                 widget.device.icon == Icons.light_rounded))
              _buildSunsetToggle(th),
            if (widget.device.type == DeviceType.light &&
                (widget.device.icon == Icons.water_rounded ||
                 widget.device.icon == Icons.light_rounded))
              const SizedBox(height: 16),
            _buildInfoCard(th),
            const SizedBox(height: 16),
            // Voice commands card — all SnarF devices
            _buildVoiceCommands(th),
            const SizedBox(height: 16),
            _buildScheduleCard(th),
          ],
        ),
      ),
    );
  }

  // ── Hero card with manual-touch note ─────────────────────────────────────
  Widget _buildHeroCard(ThemeHelper th) {
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
          // Online / Manual mode banner
          if (!_isOnline)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.touch_app_rounded,
                      color: Colors.white, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    'Manual touch still works — glass panel always responsive',
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

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

          // Power toggle
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
          Text(_isOn ? 'ON' : 'OFF',
              style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.9))),

          // Simulate offline toggle (demo)
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => setState(() => _isOnline = !_isOnline),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: _isOnline
                          ? const Color(0xFF4ADE80)
                          : const Color(0xFFF87171),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isOnline ? 'Online · Tap to simulate offline' : 'Offline · Tap to restore',
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.85)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Live power monitoring card (sockets) ─────────────────────────────────
  Widget _buildPowerCard(ThemeHelper th) {
    return _card(
      th,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accentYellow.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.bolt_rounded,
                    color: AppColors.accentYellow, size: 20),
              ),
              const SizedBox(width: 12),
              Text('Live Power Monitoring',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: th.textPrimary)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.active.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('LIVE',
                    style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.active,
                        letterSpacing: 1)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _PowerStat(
                label: 'Current',
                value: '${_liveWatts.toStringAsFixed(1)} W',
                icon: Icons.electric_bolt_rounded,
                color: AppColors.accentYellow,
                th: th,
              ),
              _PowerStat(
                label: 'Today',
                value: '${(_liveWatts * 8 / 1000).toStringAsFixed(2)} kWh',
                icon: Icons.today_rounded,
                color: AppColors.primary,
                th: th,
              ),
              _PowerStat(
                label: 'This Month',
                value: '${(_liveWatts * 200 / 1000).toStringAsFixed(1)} kWh',
                icon: Icons.calendar_month_rounded,
                color: AppColors.accentGreen,
                th: th,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Wattage slider (simulates real-time draw)
          Row(
            children: [
              Text('Simulate load:',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: th.textSecondary)),
              Expanded(
                child: Slider(
                  value: _liveWatts,
                  min: 0,
                  max: 3600,
                  divisions: 36,
                  activeColor: AppColors.accentYellow,
                  inactiveColor: th.progressTrack,
                  onChanged: (v) => setState(() => _liveWatts = v),
                ),
              ),
              Text('${_liveWatts.round()} W',
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentYellow)),
            ],
          ),
          // Overload warning
          if (_liveWatts > 3000)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.accentRed.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.accentRed.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: AppColors.accentRed, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Overload risk — ${_liveWatts.round()} W exceeds safe limit. '
                      'SnarF will auto-cut power to prevent damage.',
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.accentRed,
                          height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ── Connectivity card ─────────────────────────────────────────────────────
  Widget _buildConnectivityCard(ThemeHelper th) {
    return _card(
      th,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Connectivity',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: th.textPrimary)),
          const SizedBox(height: 14),

          // Wi-Fi Direct — no hub row
          _ConnRow(
            icon: Icons.wifi_rounded,
            iconColor: AppColors.primary,
            label: 'Connection',
            value: _protocolLabel,
            th: th,
          ),
          const SizedBox(height: 2),

          // Remote access row
          _ConnRow(
            icon: widget.device.remoteAccess
                ? Icons.public_rounded
                : Icons.public_off_rounded,
            iconColor: widget.device.remoteAccess
                ? AppColors.active
                : AppColors.accentRed,
            label: 'Remote Access',
            value: widget.device.remoteAccess
                ? 'Active — control from anywhere'
                : 'Unavailable — check Wi-Fi',
            valueColor: widget.device.remoteAccess
                ? AppColors.active
                : AppColors.accentRed,
            th: th,
          ),
          const SizedBox(height: 2),

          // Manual fallback row
          _ConnRow(
            icon: Icons.touch_app_rounded,
            iconColor: const Color(0xFF8B5CF6),
            label: 'Manual Touch',
            value: 'Always works — no internet needed',
            valueColor: const Color(0xFF8B5CF6),
            th: th,
          ),
          const SizedBox(height: 2),

          // Hub requirement row
          _ConnRow(
            icon: Icons.router_rounded,
            iconColor: th.textSecondary,
            label: 'Hub Required',
            value: 'No — connects directly to Wi-Fi',
            th: th,
          ),
        ],
      ),
    );
  }

  // ── Device info card ───────────────────────────────────────────────────────
  Widget _buildInfoCard(ThemeHelper th) {
    return _card(
      th,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Device Info',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: th.textPrimary)),
          const SizedBox(height: 12),
          _InfoRow(label: 'Room', value: widget.device.room, th: th),
          _InfoRow(label: 'Device ID', value: widget.device.id.toUpperCase(), th: th),
          _InfoRow(label: 'Ecosystem', value: 'Tuya / Smart Life', th: th),
          _InfoRow(label: 'Brand', value: 'SnarF by NAJOD Systems', th: th),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Installation',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: th.textSecondary)),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _installColor(th),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(_installLabel,
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _installColor(th))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Schedule card with "Runs locally" badge ───────────────────────────────
  Widget _buildScheduleCard(ThemeHelper th) {
    return _card(
      th,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Schedule',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: th.textPrimary)),
              const SizedBox(width: 8),
              // "Runs locally" badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.offline_bolt_rounded,
                        size: 11, color: Color(0xFF8B5CF6)),
                    const SizedBox(width: 3),
                    Text('Runs locally',
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF8B5CF6))),
                  ],
                ),
              ),
              const Spacer(),
              // Water heater gets a "Wake Up" quick preset
              if (widget.device.icon == Icons.hot_tub_rounded)
                TextButton.icon(
                  onPressed: () => _addWakeUpPreset(),
                  icon: const Icon(Icons.alarm_rounded, size: 14),
                  label: const Text('Wake up'),
                  style: TextButton.styleFrom(
                      foregroundColor: AppColors.accentYellow,
                      padding: const EdgeInsets.only(right: 8),
                      textStyle: GoogleFonts.inter(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                ),
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
          const SizedBox(height: 4),
          Text(
            'Schedules execute on-device — internet outages won\'t stop them.',
            style: GoogleFonts.inter(
                fontSize: 11,
                color: th.textSecondary,
                fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 10),
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
            child: Text('${_brightness.round()}%',
                style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
          ),
          const SizedBox(height: 16),
          Text('Scene Presets',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: th.textPrimary)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ScenePreset(label: 'Bright',  brightness: 100, color: const Color(0xFFF59E0B), th: th,
                  onTap: () => setState(() => _brightness = 100)),
              _ScenePreset(label: 'Relax',   brightness: 60,  color: AppColors.accentOrange, th: th,
                  onTap: () => setState(() => _brightness = 60)),
              _ScenePreset(label: 'Night',   brightness: 20,  color: AppColors.accentPurple, th: th,
                  onTap: () => setState(() => _brightness = 20)),
              _ScenePreset(label: 'Off',     brightness: 0,   color: th.textHint, th: th,
                  onTap: () => setState(() { _brightness = 0; _isOn = false; })),
            ],
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
                  Text(_temperature.toStringAsFixed(1),
                      style: GoogleFonts.inter(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary)),
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
                  child: const Icon(Icons.add_rounded,
                      color: AppColors.primary),
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
              overlayShape:
                  const RoundSliderOverlayShape(overlayRadius: 20),
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
                  style:
                      GoogleFonts.inter(fontSize: 12, color: th.textHint)),
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
                    elevation: 0),
              ),
              ElevatedButton.icon(
                onPressed: () => setState(() => _curtainPosition = 50),
                icon: const Icon(Icons.linear_scale_rounded, size: 16),
                label: const Text('Half'),
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.accentOrange.withValues(alpha: 0.1),
                    foregroundColor: AppColors.accentOrange,
                    elevation: 0),
              ),
              ElevatedButton.icon(
                onPressed: () => setState(() => _curtainPosition = 100),
                icon: const Icon(Icons.vertical_align_bottom_rounded,
                    size: 16),
                label: const Text('Open'),
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primary.withValues(alpha: 0.1),
                    foregroundColor: AppColors.primary,
                    elevation: 0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Wake-up preset for water heater ─────────────────────────────────────
  void _addWakeUpPreset() {
    setState(() {
      _schedules.add({'time': '05:00', 'label': 'Turn On',  'days': 'Every day'});
      _schedules.add({'time': '06:30', 'label': 'Turn Off', 'days': 'Every day'});
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.alarm_rounded, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Text('Wake-up schedule added: On 05:00 · Off 06:30',
            style: GoogleFonts.inter()),
      ]),
      backgroundColor: AppColors.accentYellow,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 3),
    ));
  }

  // ── Glass Touch Finish Selector ──────────────────────────────────────────
  Widget _buildFinishSelector(ThemeHelper th) {
    return _card(
      th,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: (_finish == 'Black'
                      ? Colors.black
                      : Colors.white).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: th.borderColor),
                ),
                child: Icon(Icons.window_rounded,
                    size: 16,
                    color: _finish == 'Black' ? th.textPrimary : th.textSecondary),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Glass Finish',
                      style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: th.textPrimary)),
                  Text('Tempered glass · black or white',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: th.textSecondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: ['Black', 'White'].map((finish) {
              final isSel = _finish == finish;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _finish = finish),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: EdgeInsets.only(right: finish == 'Black' ? 8 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: finish == 'Black'
                          ? (isSel ? const Color(0xFF1E293B) : th.chipBg)
                          : (isSel ? const Color(0xFFF8FAFC) : th.chipBg),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSel
                            ? (finish == 'Black'
                                ? Colors.black87
                                : const Color(0xFFCBD5E1))
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: finish == 'Black'
                                ? Colors.black87
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: th.borderColor, width: 1),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(finish,
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: th.textPrimary)),
                        if (isSel) ...[
                          const SizedBox(width: 6),
                          Icon(Icons.check_circle_rounded,
                              size: 14, color: AppColors.active),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Sunset Auto-mode (Fountain / RGB LED) ────────────────────────────────
  Widget _buildSunsetToggle(ThemeHelper th) {
    const fountainColor = Color(0xFF0EA5E9);
    return _card(
      th,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: (_sunsetAuto
                              ? const Color(0xFFF59E0B)
                              : fountainColor)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _sunsetAuto
                          ? Icons.wb_twilight_rounded
                          : Icons.light_mode_rounded,
                      size: 20,
                      color: _sunsetAuto
                          ? const Color(0xFFF59E0B)
                          : fountainColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sunset Auto-mode',
                          style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: th.textPrimary)),
                      Text(
                        _sunsetAuto
                            ? 'RGB scenes switch automatically at sunset'
                            : 'Tap to enable sunset colour scenes',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: th.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              Switch.adaptive(
                value: _sunsetAuto,
                activeTrackColor: const Color(0xFFF59E0B),
                onChanged: (v) => setState(() => _sunsetAuto = v),
              ),
            ],
          ),
          if (_sunsetAuto) ...[
            const SizedBox(height: 14),
            // RGB colour scene chips shown only when auto is on
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ('Sunrise', const Color(0xFFF97316)),
                ('Day', const Color(0xFF3B82F6)),
                ('Sunset', const Color(0xFFEF4444)),
                ('Night', const Color(0xFF6366F1)),
              ].map((c) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: c.$2.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: c.$2.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8, height: 8,
                          decoration: BoxDecoration(
                              color: c.$2, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                        Text(c.$1,
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: c.$2)),
                      ],
                    ),
                  )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // ── Voice Commands card ───────────────────────────────────────────────────
  Widget _buildVoiceCommands(ThemeHelper th) {
    final deviceName = widget.device.name;
    // Generate context-appropriate example phrases
    final List<(IconData, String, String)> commands = [
      (Icons.mic_rounded,
       'Amazon Alexa',
       '"Alexa, turn ${_isOn ? 'off' : 'on'} the $deviceName"'),
      (Icons.assistant_rounded,
       'Google Home',
       '"Hey Google, turn ${_isOn ? 'off' : 'on'} the $deviceName"'),
      if (widget.device.type == DeviceType.light)
        (Icons.mic_rounded, 'Amazon Alexa',
         '"Alexa, dim the $deviceName to 30%"'),
      if (widget.device.type == DeviceType.light)
        (Icons.assistant_rounded, 'Google Home',
         '"Hey Google, set $deviceName to night mode"'),
      if (widget.device.type == DeviceType.switch_ ||
          widget.device.type == DeviceType.socket)
        (Icons.mic_rounded, 'Amazon Alexa',
         '"Alexa, turn off all lights"'),
      if (widget.device.icon == Icons.hot_tub_rounded)
        (Icons.assistant_rounded, 'Google Home',
         '"Hey Google, turn on the water heater"'),
    ];

    return _card(
      th,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00A6FF), Color(0xFF0070CC)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.record_voice_over_rounded,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Voice Control',
                      style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: th.textPrimary)),
                  Text('Alexa · Google Home',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: th.textSecondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...commands.map((cmd) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: th.inputFill,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(cmd.$1,
                          size: 14,
                          color: cmd.$2 == 'Amazon Alexa'
                              ? const Color(0xFF00A6FF)
                              : const Color(0xFF34A853)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(cmd.$3,
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                color: th.textPrimary,
                                fontStyle: FontStyle.italic)),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  void _showAddScheduleSheet(BuildContext context, ThemeHelper th) {
    TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);
    String selectedAction = 'Turn On';
    final List<String> weekDays = [
      'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
    ];
    final Set<String> selectedDays = {'Mon', 'Tue', 'Wed', 'Thu', 'Fri'};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: th.cardBg,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
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
                Text('Add Schedule',
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: th.textPrimary)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.offline_bolt_rounded,
                        size: 13, color: Color(0xFF8B5CF6)),
                    const SizedBox(width: 4),
                    Text(
                      'Runs locally — works even without internet',
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF8B5CF6),
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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
                          dialogTheme:
                              DialogThemeData(backgroundColor: th.cardBg),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) setSheet(() => selectedTime = picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.schedule_rounded,
                            color: AppColors.primary, size: 20),
                        const SizedBox(width: 12),
                        Text(selectedTime.format(ctx),
                            style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary)),
                        const Spacer(),
                        Text('Tap to change',
                            style: GoogleFonts.inter(
                                fontSize: 12, color: th.textSecondary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                          padding:
                              const EdgeInsets.symmetric(vertical: 12),
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
                        isSel
                            ? selectedDays.remove(day)
                            : selectedDays.add(day);
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color:
                              isSel ? AppColors.primary : th.chipBg,
                          shape: BoxShape.circle,
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedDays.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Select at least one day',
                              style: GoogleFonts.inter()),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ));
                        return;
                      }
                      String daysLabel;
                      if (selectedDays.length == 7) {
                        daysLabel = 'Every day';
                      } else if (selectedDays.containsAll(
                              ['Mon', 'Tue', 'Wed', 'Thu', 'Fri']) &&
                          selectedDays.length == 5) {
                        daysLabel = 'Mon–Fri';
                      } else {
                        final order = [
                          'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
                        ];
                        daysLabel = order
                            .where((d) => selectedDays.contains(d))
                            .join(', ');
                      }
                      final h = selectedTime.hour
                          .toString()
                          .padLeft(2, '0');
                      final m = selectedTime.minute
                          .toString()
                          .padLeft(2, '0');
                      setState(() => _schedules.add({
                            'time': '$h:$m',
                            'label': selectedAction,
                            'days': daysLabel,
                          }));
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(children: [
                          const Icon(Icons.check_circle_rounded,
                              color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text('Schedule added: $h:$m · $selectedAction',
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

  Widget _card(ThemeHelper th, Widget child) => Container(
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

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _PowerStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final ThemeHelper th;

  const _PowerStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.th,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 8),
        Text(value,
            style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: th.textPrimary)),
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 11, color: th.textSecondary)),
      ],
    );
  }
}

class _ConnRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;
  final ThemeHelper th;

  const _ConnRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
    required this.th,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.inter(
                        fontSize: 12, color: th.textSecondary)),
                Text(value,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: valueColor ?? th.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
            ? Border.all(
                color: AppColors.primary.withValues(alpha: 0.3))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 14,
              color: isSelected ? AppColors.primary : th.textHint),
          const SizedBox(width: 4),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? AppColors.primary
                      : th.textSecondary)),
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

class _ScenePreset extends StatelessWidget {
  final String label;
  final double brightness;
  final Color color;
  final VoidCallback onTap;
  final ThemeHelper th;

  const _ScenePreset({
    required this.label,
    required this.brightness,
    required this.color,
    required this.onTap,
    required this.th,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: brightness == 0
                  ? th.chipBg
                  : color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: brightness == 0
                    ? th.borderColor
                    : color.withValues(alpha: 0.3),
              ),
            ),
            child: Icon(
              brightness == 0
                  ? Icons.power_off_rounded
                  : Icons.wb_incandescent_rounded,
              color: brightness == 0 ? th.textHint : color,
              size: 24,
            ),
          ),
          const SizedBox(height: 5),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: th.textSecondary)),
          Text(
            brightness == 0 ? 'Off' : '${brightness.round()}%',
            style: GoogleFonts.inter(
                fontSize: 10,
                color: brightness == 0 ? th.textHint : color),
          ),
        ],
      ),
    );
  }
}

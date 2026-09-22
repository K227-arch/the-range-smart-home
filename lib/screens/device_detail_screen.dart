import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/device.dart';
import '../theme/app_colors.dart';

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
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.device.name,
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded,
                color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Hero card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: _isOn
                    ? AppColors.primaryGradient
                    : const LinearGradient(
                        colors: [Color(0xFF64748B), Color(0xFF475569)],
                      ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Icon(
                    widget.device.icon,
                    size: 64,
                    color: Colors.white.withOpacity(_isOn ? 1 : 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.device.name,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.device.room,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Power toggle
                  GestureDetector(
                    onTap: () => setState(() => _isOn = !_isOn),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(_isOn ? 0.25 : 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white.withOpacity(0.5), width: 2),
                      ),
                      child: Icon(
                        Icons.power_settings_new_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isOn ? 'ON' : 'OFF',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Device-specific controls
            _buildControls(),

            const SizedBox(height: 20),

            // Info card
            _buildInfoCard(),

            const SizedBox(height: 20),

            // Schedule
            _buildScheduleCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    switch (widget.device.type) {
      case DeviceType.light:
        return _buildLightControls();
      case DeviceType.thermostat:
      case DeviceType.airConditioner:
        return _buildThermostatControls();
      case DeviceType.curtain:
        return _buildCurtainControls();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLightControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Brightness',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.brightness_low_rounded,
                  color: AppColors.textHint),
              Expanded(
                child: Slider(
                  value: _brightness,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  activeColor: AppColors.primary,
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
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Color Temperature',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _TempButton(label: 'Warm', temp: 2700),
              _TempButton(label: 'Neutral', temp: 4000),
              _TempButton(label: 'Cool', temp: 6500),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThermostatControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Text('Temperature',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () =>
                    setState(() => _temperature = (_temperature - 0.5).clamp(16, 30)),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.remove_rounded),
                ),
              ),
              const SizedBox(width: 24),
              Column(
                children: [
                  Text(
                    '${_temperature.toStringAsFixed(1)}',
                    style: GoogleFonts.inter(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  Text('°C', style: GoogleFonts.inter(fontSize: 18, color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: () =>
                    setState(() => _temperature = (_temperature + 0.5).clamp(16, 30)),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add_rounded, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Mode buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['Cool', 'Heat', 'Fan', 'Auto'].map((m) {
              final icons = [
                Icons.ac_unit_rounded,
                Icons.local_fire_department_rounded,
                Icons.air_rounded,
                Icons.autorenew_rounded,
              ];
              final idx = ['Cool', 'Heat', 'Fan', 'Auto'].indexOf(m);
              return _ModeButton(
                  label: m, icon: icons[idx], isSelected: m == 'Cool');
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCurtainControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Curtain Position',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 8,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              activeTrackColor: AppColors.accentOrange,
              inactiveTrackColor: const Color(0xFFE2E8F0),
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
                      fontSize: 12, color: AppColors.textHint)),
              Text('${_curtainPosition.round()}%',
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentOrange)),
              Text('Open',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.textHint)),
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
                  backgroundColor: const Color(0xFFF1F5F9),
                  foregroundColor: AppColors.textPrimary,
                  elevation: 0,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => setState(() => _curtainPosition = 50),
                icon: const Icon(Icons.linear_scale_rounded, size: 16),
                label: const Text('Half'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentOrange.withOpacity(0.1),
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
                  backgroundColor: AppColors.primary.withOpacity(0.1),
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

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Device Info',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 12),
          _InfoRow(label: 'Room', value: widget.device.room),
          _InfoRow(
              label: 'Protocol',
              value: widget.device.protocol.name.toUpperCase()),
          _InfoRow(label: 'Status', value: 'Online'),
          _InfoRow(label: 'Device ID', value: widget.device.id.toUpperCase()),
          _InfoRow(label: 'Ecosystem', value: 'Tuya / Smart Life'),
        ],
      ),
    );
  }

  Widget _buildScheduleCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Schedule',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600, fontSize: 15)),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Add'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _ScheduleRow(time: '07:00', label: 'Turn On', days: 'Mon–Fri'),
          _ScheduleRow(time: '22:30', label: 'Turn Off', days: 'Every day'),
        ],
      ),
    );
  }
}

class _TempButton extends StatelessWidget {
  final String label;
  final int temp;

  const _TempButton({required this.label, required this.temp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label,
          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500)),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;

  const _ModeButton(
      {required this.label, required this.icon, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withOpacity(0.1)
            : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
        border: isSelected
            ? Border.all(color: AppColors.primary.withOpacity(0.3))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 14,
              color: isSelected ? AppColors.primary : AppColors.textHint),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
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

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 13, color: AppColors.textSecondary)),
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  final String time;
  final String label;
  final String days;

  const _ScheduleRow(
      {required this.time, required this.label, required this.days});

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
              color: AppColors.primary.withOpacity(0.08),
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
                        fontSize: 14, fontWeight: FontWeight.w600)),
                Text(days,
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.textSecondary)),
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

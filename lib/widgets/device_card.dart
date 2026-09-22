import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/device.dart';
import '../theme/app_colors.dart';

class DeviceCard extends StatelessWidget {
  final Device device;
  final VoidCallback onToggle;
  final VoidCallback? onTap;

  const DeviceCard({
    super.key,
    required this.device,
    required this.onToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOn = device.isOn;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isOn ? Colors.white : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isOn
                ? AppColors.primary.withOpacity(0.15)
                : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
          boxShadow: isOn
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top row: icon + toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isOn
                        ? device.iconColor.withOpacity(0.12)
                        : const Color(0xFFEEF2FF).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    device.icon,
                    color: isOn ? device.iconColor : AppColors.textHint,
                    size: 20,
                  ),
                ),
                _SmallToggle(isOn: isOn, onTap: onToggle),
              ],
            ),

            const SizedBox(height: 10),

            // Device name
            Text(
              device.name,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isOn ? AppColors.textPrimary : AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Room + status
            Row(
              children: [
                Expanded(
                  child: Text(
                    device.room,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Protocol badge
                _ProtocolBadge(protocol: device.protocol),
              ],
            ),

            // Extra attribute row if device is on
            if (isOn && device.attributes.isNotEmpty) ...[
              const SizedBox(height: 4),
              _buildAttribute(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAttribute() {
    final attrs = device.attributes;
    if (device.type == DeviceType.thermostat) {
      return Text(
        '${attrs['temp']}°C · ${attrs['mode']}',
        style: GoogleFonts.inter(
          fontSize: 11,
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (device.type == DeviceType.airConditioner) {
      return Text(
        'Temp: ${attrs['temp']}°  Wind: ${attrs['wind']}',
        style: GoogleFonts.inter(
          fontSize: 10,
          color: AppColors.textHint,
        ),
      );
    } else if (device.type == DeviceType.light) {
      return Row(
        children: [
          Icon(Icons.brightness_6_rounded, size: 11, color: AppColors.textHint),
          const SizedBox(width: 3),
          Text(
            '${attrs['brightness']}%',
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.textHint),
          ),
        ],
      );
    } else if (device.type == DeviceType.socket) {
      return Text(
        '${attrs['power']} W',
        style: GoogleFonts.inter(
          fontSize: 11,
          color: AppColors.accentGreen,
          fontWeight: FontWeight.w600,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class _SmallToggle extends StatelessWidget {
  final bool isOn;
  final VoidCallback onTap;

  const _SmallToggle({required this.isOn, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 20,
        decoration: BoxDecoration(
          color: isOn ? AppColors.primary : const Color(0xFFCBD5E1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProtocolBadge extends StatelessWidget {
  final ProtocolType protocol;

  const _ProtocolBadge({required this.protocol});

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;
    switch (protocol) {
      case ProtocolType.zigbee:
        label = 'Zigbee';
        color = AppColors.accentPurple;
        break;
      case ProtocolType.wifi:
        label = 'Wi-Fi';
        color = AppColors.accentBlue;
        break;
      case ProtocolType.bluetooth:
        label = 'BT';
        color = AppColors.accentCyan;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 9,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

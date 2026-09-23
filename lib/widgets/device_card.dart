import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/device.dart';
import '../theme/app_colors.dart';
import '../theme/theme_helper.dart';

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

  bool get _isOverloaded =>
      device.type == DeviceType.socket &&
      (device.powerWatts ?? 0) > 3000;

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    final isOn = device.isOn;

    final cardColor = isOn
        ? (th.isDark ? AppColors.bgCard : Colors.white)
        : (th.isDark ? AppColors.bgCardLight : const Color(0xFFF8FAFC));

    // Overloaded sockets get a red border
    final borderColor = _isOverloaded
        ? AppColors.accentRed.withValues(alpha: 0.5)
        : isOn
            ? AppColors.primary.withValues(alpha: 0.15)
            : th.borderColor;

    final shadow = isOn
        ? [
            BoxShadow(
              color: (_isOverloaded ? AppColors.accentRed : AppColors.primary)
                  .withValues(alpha: th.isDark ? 0.12 : 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ]
        : th.cardShadow;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: shadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top row: icon + toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: isOn
                            ? device.iconColor.withValues(alpha: 0.12)
                            : th.chipBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        device.icon,
                        color: isOn ? device.iconColor : th.textHint,
                        size: 20,
                      ),
                    ),
                    // Remote access dot — top-right of icon
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: device.remoteAccess
                              ? AppColors.active
                              : AppColors.accentRed,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: cardColor, width: 1.5),
                        ),
                      ),
                    ),
                  ],
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
                color: isOn ? th.textPrimary : th.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Room + protocol badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    device.room,
                    style:
                        GoogleFonts.inter(fontSize: 11, color: th.textHint),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _ProtocolBadge(protocol: device.protocol),
              ],
            ),

            if (isOn) ...[
              const SizedBox(height: 4),
              _buildStatus(th),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatus(ThemeHelper th) {
    // Overload warning takes priority
    if (_isOverloaded) {
      return Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              size: 12, color: AppColors.accentRed),
          const SizedBox(width: 4),
          Text(
            'Overload ${device.powerWatts!.round()} W',
            style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.accentRed,
                fontWeight: FontWeight.w700),
          ),
        ],
      );
    }

    final attrs = device.attributes;
    switch (device.type) {
      case DeviceType.socket:
        final watts = device.powerWatts ?? attrs['power'] ?? 0.0;
        return Row(
          children: [
            const Icon(Icons.bolt_rounded,
                size: 11, color: AppColors.accentYellow),
            const SizedBox(width: 3),
            Text(
              '${watts is double ? watts.toStringAsFixed(1) : watts} W',
              style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.accentYellow,
                  fontWeight: FontWeight.w600),
            ),
          ],
        );
      case DeviceType.light:
        if (attrs.containsKey('brightness')) {
          return Row(
            children: [
              Icon(Icons.brightness_6_rounded,
                  size: 11, color: th.textHint),
              const SizedBox(width: 3),
              Text('${attrs['brightness']}%',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: th.textHint)),
            ],
          );
        }
        return const SizedBox.shrink();
      case DeviceType.thermostat:
      case DeviceType.airConditioner:
        return Text(
          '${attrs['temp']}°C · ${attrs['mode'] ?? ''}',
          style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.primary,
              fontWeight: FontWeight.w500),
        );
      default:
        // Switches — show "Manual always works" micro hint
        return Row(
          children: [
            Icon(Icons.touch_app_rounded,
                size: 11, color: th.textHint),
            const SizedBox(width: 3),
            Text('Touch always active',
                style: GoogleFonts.inter(
                    fontSize: 10, color: th.textHint)),
          ],
        );
    }
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
          alignment:
              isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
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
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
            fontSize: 9, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

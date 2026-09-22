import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Resolves semantic color tokens based on the current brightness.
/// Use `ThemeHelper.of(context)` anywhere inside a widget tree.
class ThemeHelper {
  final bool isDark;

  const ThemeHelper(this.isDark);

  factory ThemeHelper.of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return ThemeHelper(brightness == Brightness.dark);
  }

  // ─── Backgrounds ──────────────────────────────────────────────────────────
  Color get screenBg   => isDark ? AppColors.bgDark       : AppColors.bgLight;
  Color get cardBg     => isDark ? AppColors.bgCard       : Colors.white;
  Color get topBarBg   => isDark ? AppColors.bgCard       : Colors.white;
  Color get chipBg     => isDark ? AppColors.bgCardLight  : const Color(0xFFF1F5F9);
  Color get inputFill  => isDark ? AppColors.bgCardLight  : const Color(0xFFF1F5F9);
  Color get modalBg    => isDark ? AppColors.bgCard       : Colors.white;

  /// Light-mode tinted banner (e.g. AI tips), dark-mode subtle card
  Color get bannerBg   => isDark ? AppColors.bgCardLight  : const Color(0xFFEFF6FF);
  Color get bannerBorder => isDark
      ? Colors.white.withValues(alpha: 0.06)
      : AppColors.primary.withValues(alpha: 0.2);

  // ─── Dividers ─────────────────────────────────────────────────────────────
  Color get divider => isDark
      ? Colors.white.withValues(alpha: 0.06)
      : const Color(0xFFE2E8F0);

  // ─── Text ─────────────────────────────────────────────────────────────────
  Color get textPrimary   => isDark ? AppColors.textOnDark          : AppColors.textPrimary;
  Color get textSecondary => isDark ? AppColors.textOnDarkSecondary : AppColors.textSecondary;
  Color get textHint      => isDark ? const Color(0xFF64748B)       : AppColors.textHint;

  // ─── Icons ────────────────────────────────────────────────────────────────
  Color get iconPrimary   => isDark ? AppColors.textOnDark          : AppColors.textPrimary;
  Color get iconSecondary => isDark ? AppColors.textOnDarkSecondary : AppColors.textSecondary;

  // ─── Borders ──────────────────────────────────────────────────────────────
  Color get borderColor => isDark
      ? Colors.white.withValues(alpha: 0.08)
      : const Color(0xFFE2E8F0);

  // ─── Shadows ──────────────────────────────────────────────────────────────
  /// Use instead of AppColors.cardShadow so shadows are invisible in dark mode.
  List<BoxShadow> get cardShadow => isDark
      ? []
      : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ];

  List<BoxShadow> get elevatedShadow => isDark
      ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ]
      : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ];

  // ─── Misc interactive surfaces ────────────────────────────────────────────
  /// Neutral chip/button pressed bg
  Color get pressedBg => isDark
      ? Colors.white.withValues(alpha: 0.06)
      : const Color(0xFFE2E8F0);

  /// Camera thumbnail / unselected card bg in Security screen
  Color get cameraCardBg => isDark ? AppColors.bgCardLight : Colors.white;

  /// Progress-bar track background
  Color get progressTrack => isDark
      ? Colors.white.withValues(alpha: 0.1)
      : const Color(0xFFE2E8F0);

  /// Waveform / note box fill
  Color get subtleFill => isDark ? AppColors.bgCardLight : const Color(0xFFF1F5F9);

  /// Meeting-minutes tinted box
  Color get minutesBg => isDark ? AppColors.bgCardLight : const Color(0xFFEFF6FF);
  Color get minutesBorder => isDark
      ? Colors.white.withValues(alpha: 0.06)
      : AppColors.primary.withValues(alpha: 0.15);

  /// Reminder box (warm tint)
  Color get reminderBg => isDark ? const Color(0xFF2D1F0A) : const Color(0xFFFFF7ED);
}

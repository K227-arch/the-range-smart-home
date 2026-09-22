import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Resolves colors based on the current brightness.
/// Use `ThemeHelper.of(context)` anywhere inside a widget tree.
class ThemeHelper {
  final bool isDark;

  const ThemeHelper(this.isDark);

  factory ThemeHelper.of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return ThemeHelper(brightness == Brightness.dark);
  }

  // ─── Backgrounds ──────────────────────────────────────────────────────────
  Color get screenBg => isDark ? AppColors.bgDark : AppColors.bgLight;
  Color get cardBg => isDark ? AppColors.bgCard : Colors.white;
  Color get topBarBg => isDark ? AppColors.bgCard : Colors.white;
  Color get chipBg => isDark ? AppColors.bgCardLight : const Color(0xFFF1F5F9);
  Color get divider => isDark
      ? Colors.white.withValues(alpha: 0.06)
      : const Color(0xFFE2E8F0);

  // ─── Text ─────────────────────────────────────────────────────────────────
  Color get textPrimary =>
      isDark ? AppColors.textOnDark : AppColors.textPrimary;
  Color get textSecondary =>
      isDark ? AppColors.textOnDarkSecondary : AppColors.textSecondary;
  Color get textHint =>
      isDark ? const Color(0xFF64748B) : AppColors.textHint;

  // ─── Icons ────────────────────────────────────────────────────────────────
  Color get iconPrimary =>
      isDark ? AppColors.textOnDark : AppColors.textPrimary;
  Color get iconSecondary =>
      isDark ? AppColors.textOnDarkSecondary : AppColors.textSecondary;

  // ─── Input ────────────────────────────────────────────────────────────────
  Color get inputFill =>
      isDark ? AppColors.bgCardLight : const Color(0xFFF1F5F9);

  // ─── Borders ──────────────────────────────────────────────────────────────
  Color get borderColor =>
      isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0);
}

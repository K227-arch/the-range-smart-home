import 'package:flutter/material.dart';

class AppColors {
  // Primary brand colors
  static const Color primary = Color(0xFF2563EB);      // Blue accent
  static const Color primaryLight = Color(0xFFEFF6FF);
  static const Color primaryDark = Color(0xFF1D4ED8);

  // Background
  static const Color bgDark = Color(0xFF0F172A);       // Main dark bg
  static const Color bgCard = Color(0xFF1E293B);       // Card dark
  static const Color bgCardLight = Color(0xFF334155);  // Elevated card
  static const Color bgLight = Color(0xFFF0F4FF);      // Light screen bg
  static const Color bgWhite = Color(0xFFFFFFFF);

  // Surface
  static const Color surface = Color(0xFF1E293B);
  static const Color surfaceVariant = Color(0xFF263248);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint = Color(0xFF94A3B8);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textOnDarkSecondary = Color(0xFFCBD5E1);

  // Device status
  static const Color active = Color(0xFF22C55E);       // Green - on
  static const Color inactive = Color(0xFF475569);     // Slate - off
  static const Color warning = Color(0xFFF59E0B);      // Amber
  static const Color error = Color(0xFFEF4444);        // Red
  static const Color info = Color(0xFF06B6D4);         // Cyan

  // Category accent colors
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentOrange = Color(0xFFF97316);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color accentRed = Color(0xFFEF4444);
  static const Color accentYellow = Color(0xFFEAB308);
  static const Color accentPink = Color(0xFFEC4899);

  // Toggle / Switch
  static const Color toggleOn = Color(0xFF2563EB);
  static const Color toggleOff = Color(0xFF334155);

  // Bottom nav
  static const Color navSelected = Color(0xFF2563EB);
  static const Color navUnselected = Color(0xFF94A3B8);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
  );

  static const LinearGradient energyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF065F46), Color(0xFF047857)],
  );

  static const LinearGradient aiGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
  );

  // Card shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}

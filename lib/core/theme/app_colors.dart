import 'package:flutter/material.dart';

class AppColors {
  // Theme Backgrounds
  static const Color backgroundDb = Color(0xFF090D16); // Very deep navy-black
  static const Color cardBg = Color(0xFF161C2C); // Deep card color
  static const Color cardBgLighter = Color(0xFF222B43); // Hover or highlighted card

  // Neon Branding
  static const Color primary = Color(0xFF9D4EDD); // Electric neon purple
  static const Color primaryLight = Color(0xFFC77DFF);
  static const Color accentCyan = Color(0xFF00F5D4); // Neon cyan
  static const Color accentPink = Color(0xFFF72585); // Neon pink
  static const Color accentGold = Color(0xFFFFB703); // Premium gold for VIP passes
  
  // Status Colors
  static const Color success = Color(0xFF2EC4B6); // Mint green
  static const Color warning = Color(0xFFFF9F1C); // Neon orange
  static const Color error = Color(0xFFE63946); // Crimson red
  static const Color disabled = Color(0xFF4A5568); // Dark grey

  // Text Colors
  static const Color textPrimary = Color(0xFFF8F9FA); // Off-white
  static const Color textSecondary = Color(0xFFADB5BD); // Light grey
  static const Color textMuted = Color(0xFF6C757D); // Medium grey

  // Gradients for tickets
  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF7B2CBF), Color(0xFF9D4EDD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyanGradient = LinearGradient(
    colors: [Color(0xFF00B4D8), Color(0xFF00F5D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFE5A93B), Color(0xFFFFD166)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1F2937), Color(0xFF111827)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient redGradient = LinearGradient(
    colors: [Color(0xFFE63946), Color(0xFFD62828)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF070A11), Color(0xFF121B2D)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

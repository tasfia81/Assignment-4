import 'package:flutter/material.dart';

class AppColors {
  // Theme Backgrounds
  static const Color backgroundDb = Color(0xFF060913); // Rich ultra-dark obsidian blue
  static const Color cardBg = Color(0xFF0F1626); // Sophisticated deep slate
  static const Color cardBgLighter = Color(0xFF1B243B); // Interactive card highlight

  // Neon Branding
  static const Color primary = Color(0xFF9D4EDD); // Electric violet-purple
  static const Color primaryLight = Color(0xFFC77DFF);
  static const Color accentCyan = Color(0xFF00F5D4); // Cyber neon cyan
  static const Color accentPink = Color(0xFFF72585); // Hot neon pink
  static const Color accentGold = Color(0xFFE5A93B); // Regal champagne gold
  
  // Status Colors
  static const Color success = Color(0xFF00F5D4); // Electric cyan-green for verified
  static const Color warning = Color(0xFFFF9F1C); // Neon security alert orange
  static const Color error = Color(0xFFF72585); // Cyber red/pink for error/expired
  static const Color disabled = Color(0xFF2C354A); // Muted dark slate

  // Text Colors
  static const Color textPrimary = Color(0xFFF8F9FA); // Crisp pearl white
  static const Color textSecondary = Color(0xFF909BB6); // Sleek steel grey
  static const Color textMuted = Color(0xFF515D7A); // Deep dark grey

  // Holographic Colors (For VIP Pass overlay shimmer)
  static const List<Color> holoColors = [
    Color(0x33FF007F), // Glowing Pink
    Color(0x337B2CBF), // Deep Purple
    Color(0x3300F5D4), // Cyan
    Color(0x33FFB703), // Gold
    Color(0x3300F5D4), // Cyan
    Color(0x33FF007F), // Glowing Pink
  ];

  // Gradients for tickets
  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF5A189A), Color(0xFF9D4EDD), Color(0xFF7B2CBF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyanGradient = LinearGradient(
    colors: [Color(0xFF03045E), Color(0xFF0077B6), Color(0xFF00B4D8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFF7A5416), Color(0xFFC59B27), Color(0xFFE5A93B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF141923), Color(0xFF0B0E14)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient redGradient = LinearGradient(
    colors: [Color(0xFF590D22), Color(0xFF800F2F), Color(0xFFA21232)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF050811), Color(0xFF0B1021)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Mesh gradient animating blobs colors
  static const Color meshBlob1 = Color(0x1F7B2CBF); // Low opacity purple
  static const Color meshBlob2 = Color(0x1900F5D4); // Low opacity cyan
  static const Color meshBlob3 = Color(0x14F72585); // Low opacity pink
}

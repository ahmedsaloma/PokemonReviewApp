import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFF0000);
  static const Color primaryDark = Color(0xFFCC0000);
  static const Color accent = Color(0xFFFFCB05);
  // Using background-light from Stitch
  static const Color background = Color(0xFFF8FAFC); 
  // White card
  static const Color card = Color(0xFFFFFFFF);
  // slate-900
  static const Color textPrimary = Color(0xFF0F172A);
  // slate-500
  static const Color textMuted = Color(0xFF64748B);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Pokemon type colors
  static const Map<String, Color> typeColors = {
    'Fire': Color(0xFFFF6B35),
    'Water': Color(0xFF5090D3),
    'Grass': Color(0xFF62B957),
    'Electric': Color(0xFFF4D23C),
    'Psychic': Color(0xFFFA7179),
    'Ice': Color(0xFF74CEC0),
    'Dragon': Color(0xFF0C6AC8),
    'Dark': Color(0xFF595761),
    'Fairy': Color(0xFFEC8FE6),
    'Normal': Color(0xFF9099A1),
    'Fighting': Color(0xFFCE416B),
    'Flying': Color(0xFF89AAE3),
    'Poison': Color(0xFFB567CE),
    'Ground': Color(0xFFD97845),
    'Rock': Color(0xFFC5B78C),
    'Bug': Color(0xFF91C12F),
    'Ghost': Color(0xFF5269AC),
    'Steel': Color(0xFF5A8EA2),
  };

  static Color typeColor(String type) =>
      typeColors[type] ?? const Color(0xFF9099A1);
}

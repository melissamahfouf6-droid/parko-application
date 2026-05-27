import 'package:flutter/material.dart';

export 'parko_palette.dart';

class ParkoColors {
  // Brand
  static const sky = Color(0xFF0EA5E9);
  static const green = Color(0xFF10B981);
  static const amber = Color(0xFFF59E0B);
  static const red = Color(0xFFEF4444);
  static const purple = Color(0xFF8B5CF6);
  static const gray = Color(0xFF64748B);

  // Neutrals
  static const background = Color(0xFFF8FAFC);
  static const card = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);
  static const border = Color(0xFFE2E8F0);

  static const gradient = LinearGradient(
    colors: [sky, green],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}


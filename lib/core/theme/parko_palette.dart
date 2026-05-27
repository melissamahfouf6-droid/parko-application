import 'package:flutter/material.dart';

import 'parko_colors.dart';

/// Semantic neutrals that follow light / dark [ThemeData].
@immutable
class ParkoPalette extends ThemeExtension<ParkoPalette> {
  const ParkoPalette({
    required this.background,
    required this.card,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.panel,
    required this.inputFill,
  });

  final Color background;
  final Color card;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  /// Floating controls on the map (search bar, round buttons, chips).
  final Color panel;
  final Color inputFill;

  static const light = ParkoPalette(
    background: ParkoColors.background,
    card: ParkoColors.card,
    textPrimary: ParkoColors.textPrimary,
    textSecondary: ParkoColors.textSecondary,
    border: ParkoColors.border,
    panel: Colors.white,
    inputFill: Colors.white,
  );

  static const dark = ParkoPalette(
    background: Color(0xFF0F172A),
    card: Color(0xFF1E293B),
    textPrimary: Color(0xFFF1F5F9),
    textSecondary: Color(0xFF94A3B8),
    border: Color(0xFF334155),
    panel: Color(0xFF1E293B),
    inputFill: Color(0xFF1E293B),
  );

  @override
  ParkoPalette copyWith({
    Color? background,
    Color? card,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? panel,
    Color? inputFill,
  }) {
    return ParkoPalette(
      background: background ?? this.background,
      card: card ?? this.card,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      panel: panel ?? this.panel,
      inputFill: inputFill ?? this.inputFill,
    );
  }

  @override
  ParkoPalette lerp(ParkoPalette? other, double t) {
    if (other == null) return this;
    return ParkoPalette(
      background: Color.lerp(background, other.background, t)!,
      card: Color.lerp(card, other.card, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      panel: Color.lerp(panel, other.panel, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
    );
  }
}

extension ParkoPaletteContext on BuildContext {
  ParkoPalette get parko => Theme.of(this).extension<ParkoPalette>() ?? ParkoPalette.light;
}

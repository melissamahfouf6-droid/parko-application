import 'package:flutter/material.dart';

import 'parko_colors.dart';
import 'parko_palette.dart';

/// Typography aligned to Parko spec sizes; uses bundled Material fonts (no network at runtime).
class ParkoTheme {
  static const String _font = 'Roboto';

  static TextTheme _textTheme(Color primary) {
    TextStyle s(double size, FontWeight w) => TextStyle(
          fontFamily: _font,
          fontSize: size,
          fontWeight: w,
          color: primary,
        );
    return TextTheme(
      headlineSmall: s(24, FontWeight.w700),
      titleLarge: s(20, FontWeight.w700),
      titleMedium: s(18, FontWeight.w600),
      titleSmall: s(16, FontWeight.w600),
      bodyLarge: s(16, FontWeight.w400),
      bodyMedium: s(14, FontWeight.w400),
      bodySmall: s(12, FontWeight.w400),
      labelLarge: s(14, FontWeight.w600),
    );
  }

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: _font,
      scaffoldBackgroundColor: ParkoColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ParkoColors.sky,
        brightness: Brightness.light,
        primary: ParkoColors.sky,
        secondary: ParkoColors.green,
        tertiary: ParkoColors.amber,
        error: ParkoColors.red,
        surface: ParkoColors.card,
      ),
    );

    final textTheme = _textTheme(ParkoColors.textPrimary);

    return base.copyWith(
      extensions: const [ParkoPalette.light],
      textTheme: textTheme,
      dividerColor: ParkoColors.border,
      appBarTheme: const AppBarTheme(
        backgroundColor: ParkoColors.background,
        foregroundColor: ParkoColors.textPrimary,
        elevation: 0,
      ),
      drawerTheme: const DrawerThemeData(backgroundColor: ParkoColors.background),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: ParkoColors.card,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: const CardTheme(
        color: ParkoColors.card,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ParkoPalette.light.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: ParkoColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: ParkoColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: ParkoColors.sky, width: 1.4),
        ),
      ),
    );
  }

  static ThemeData dark() {
    const palette = ParkoPalette.dark;

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: _font,
      scaffoldBackgroundColor: palette.background,
      colorScheme: ColorScheme.dark(
        primary: ParkoColors.sky,
        secondary: ParkoColors.green,
        tertiary: ParkoColors.amber,
        error: ParkoColors.red,
        surface: palette.card,
        onSurface: palette.textPrimary,
        onSurfaceVariant: palette.textSecondary,
        outline: palette.border,
      ),
    );

    final textTheme = _textTheme(palette.textPrimary);

    return base.copyWith(
      extensions: const [ParkoPalette.dark],
      textTheme: textTheme,
      dividerColor: palette.border,
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        foregroundColor: palette.textPrimary,
        elevation: 0,
      ),
      drawerTheme: DrawerThemeData(backgroundColor: palette.background),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.card,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardTheme(
        color: palette.card,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.inputFill,
        labelStyle: TextStyle(color: palette.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: palette.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: palette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: ParkoColors.sky, width: 1.4),
        ),
      ),
      switchTheme: const SwitchThemeData(
        thumbColor: MaterialStatePropertyAll(ParkoColors.sky),
      ),
    );
  }
}

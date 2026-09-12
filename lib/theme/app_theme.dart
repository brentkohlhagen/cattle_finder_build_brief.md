import 'package:flutter/material.dart';

/// Ink / ochre / rust palette pulled from paddock + saleyard-board materials,
/// matching the validated web prototype rather than a generic app palette.
class AppColors {
  static const ink = Color(0xFF23261F);
  static const inkSoft = Color(0xFF2E3227);
  static const panel = Color(0xFFF4F0E4);
  static const panelEdge = Color(0xFFDDD6C2);
  static const bone = Color(0xFFEFE8D8);
  static const boneDim = Color(0xFFB9B199);
  static const ochre = Color(0xFFC98A2C);
  static const ochreDeep = Color(0xFF9C6A1E);
  static const rust = Color(0xFFA3502E);
  static const sage = Color(0xFF6F8055);
  static const stone = Color(0xFF7A7561);
  static const fieldBg = Color(0xFFFCFAF3);
  static const chipHighlight = Color(0xFFEADFC4);
}

/// Oswald for condensed sign-painted headings, Inter for UI body copy,
/// IBM Plex Mono for numbers — weight, price and distance are the product.
///
/// All three are bundled as local assets (see pubspec.yaml) rather than
/// fetched at runtime, so text renders reliably without network access.
/// Oswald and Inter are variable fonts; the visual weight comes from the
/// `wght` font variation rather than from separate font files per weight.
class AppFonts {
  static TextStyle oswald({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.ink,
    double? letterSpacing,
  }) =>
      TextStyle(
        fontFamily: 'Oswald',
        fontVariations: [FontVariation('wght', fontWeight.value.toDouble())],
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      );

  static TextStyle inter({
    double fontSize = 13,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.ink,
  }) =>
      TextStyle(
        fontFamily: 'Inter',
        fontVariations: [FontVariation('wght', fontWeight.value.toDouble())],
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );

  static TextStyle mono({
    double fontSize = 13,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.ink,
  }) =>
      TextStyle(
        fontFamily: 'IBMPlexMono',
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.panel,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.ochre,
      brightness: Brightness.light,
    ),
    fontFamily: 'Inter',
  );
}

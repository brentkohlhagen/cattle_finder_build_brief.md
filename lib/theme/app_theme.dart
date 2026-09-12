import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
class AppFonts {
  static TextStyle oswald({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.ink,
    double? letterSpacing,
  }) =>
      GoogleFonts.oswald(
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
      GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );

  static TextStyle mono({
    double fontSize = 13,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.ink,
  }) =>
      GoogleFonts.ibmPlexMono(
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
    textTheme: GoogleFonts.interTextTheme(),
  );
}

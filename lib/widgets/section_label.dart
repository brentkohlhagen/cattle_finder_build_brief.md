import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SectionLabel extends StatelessWidget {
  final String text;

  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: AppFonts.oswald(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.stone,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

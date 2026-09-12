import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MonoStat extends StatelessWidget {
  final String label;
  final String value;

  const MonoStat({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: AppFonts.inter(fontSize: 9.5, color: AppColors.stone),
        ),
        Text(
          value,
          style: AppFonts.mono(fontSize: 12.5, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

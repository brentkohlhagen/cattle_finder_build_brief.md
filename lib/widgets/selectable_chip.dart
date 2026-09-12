import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SelectableChip extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;
  final String label;

  const SelectableChip({
    super.key,
    required this.active,
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? AppColors.ochre : Colors.transparent,
      borderRadius: BorderRadius.circular(7),
      child: InkWell(
        borderRadius: BorderRadius.circular(7),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: active ? AppColors.ochreDeep : AppColors.panelEdge,
            ),
          ),
          child: Text(
            label,
            style: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

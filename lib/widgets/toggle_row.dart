import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ToggleRow extends StatelessWidget {
  final bool checked;
  final ValueChanged<bool> onChanged;
  final String label;

  const ToggleRow({
    super.key,
    required this.checked,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!checked),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Switch(
            value: checked,
            onChanged: onChanged,
            activeTrackColor: AppColors.ochre,
            activeThumbColor: Colors.white,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              label,
              style: AppFonts.inter(fontSize: 13.5),
            ),
          ),
        ],
      ),
    );
  }
}

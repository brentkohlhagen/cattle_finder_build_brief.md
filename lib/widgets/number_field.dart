import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

/// Digits-only numeric input, mirroring the prototype's `NumberField`.
/// Emits `null` when the field is cleared.
class NumberField extends StatelessWidget {
  final int? value;
  final ValueChanged<int?> onChanged;
  final String placeholder;
  final double width;

  const NumberField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.placeholder,
    this.width = 78,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        key: ValueKey(value),
        initialValue: value?.toString() ?? '',
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: AppFonts.mono(fontSize: 14, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: AppFonts.mono(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.boneDim,
          ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          filled: true,
          fillColor: AppColors.fieldBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.panelEdge),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.panelEdge),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.ochreDeep),
          ),
        ),
        onChanged: (text) => onChanged(text.isEmpty ? null : int.tryParse(text)),
      ),
    );
  }
}

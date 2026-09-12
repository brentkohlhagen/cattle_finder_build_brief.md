import 'package:flutter/material.dart';
import '../models/search_filters.dart';
import '../theme/app_theme.dart';
import '../widgets/selectable_chip.dart';
import '../widgets/section_label.dart';

class SubmitScreen extends StatelessWidget {
  final String submitUrl;
  final ValueChanged<String> onSubmitUrlChanged;
  final String? submitBreed;
  final ValueChanged<String> onSubmitBreedChanged;
  final VoidCallback onSubmit;

  const SubmitScreen({
    super.key,
    required this.submitUrl,
    required this.onSubmitUrlChanged,
    required this.submitBreed,
    required this.onSubmitBreedChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final canSubmit = submitUrl.trim().isNotEmpty;

    return ListView(
      children: [
        const SectionLabel('Submit a listing'),
        Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Text(
            'Paste a link to a sale listing — from an agent, saleyard catalogue, or your own advertisement. '
            'Listings from recognised sources appear straight away; anything else goes to a short review queue first.',
            style: AppFonts.inter(fontSize: 12.5, color: AppColors.stone),
          ),
        ),
        const SectionLabel('Listing link'),
        TextFormField(
          key: ValueKey(submitUrl),
          initialValue: submitUrl,
          onChanged: onSubmitUrlChanged,
          style: AppFonts.inter(fontSize: 13),
          decoration: InputDecoration(
            hintText: 'https://…',
            filled: true,
            fillColor: AppColors.fieldBg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: AppColors.panelEdge),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: AppColors.panelEdge),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const SectionLabel('Breed'),
        Padding(
          padding: const EdgeInsets.only(bottom: 22),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: kBreeds
                .map((b) => SelectableChip(
                      active: submitBreed == b,
                      onTap: () => onSubmitBreedChanged(b),
                      label: b,
                    ))
                .toList(),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: canSubmit ? onSubmit : null,
            icon: const Icon(Icons.send, size: 15),
            label: Text(
              'Send for review',
              style: AppFonts.oswald(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.3),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: canSubmit ? AppColors.ochre : AppColors.panelEdge,
              foregroundColor: AppColors.ink,
              disabledBackgroundColor: AppColors.panelEdge,
              disabledForegroundColor: AppColors.ink,
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }
}

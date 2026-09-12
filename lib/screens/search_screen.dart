import 'package:flutter/material.dart';
import '../models/search_filters.dart';
import '../theme/app_theme.dart';
import '../widgets/selectable_chip.dart';
import '../widgets/number_field.dart';
import '../widgets/section_label.dart';
import '../widgets/toggle_row.dart';

enum SearchMode { simple, advanced }

class SearchScreen extends StatelessWidget {
  final SearchMode mode;
  final ValueChanged<SearchMode> onModeChanged;
  final SearchFilters filters;
  final ValueChanged<SearchFilters> onFiltersChanged;
  final String location;
  final ValueChanged<String> onLocationChanged;
  final VoidCallback onSearch;
  final VoidCallback onExample;

  const SearchScreen({
    super.key,
    required this.mode,
    required this.onModeChanged,
    required this.filters,
    required this.onFiltersChanged,
    required this.location,
    required this.onLocationChanged,
    required this.onSearch,
    required this.onExample,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        InkWell(
          onTap: onExample,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 18),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.chipHighlight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.ochreDeep, style: BorderStyle.solid),
            ),
            child: Text(
              'Try an example — Speckle Park, 320kg+, within 700km of Harlin',
              style: AppFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w500, color: AppColors.ochreDeep),
            ),
          ),
        ),

        const SectionLabel('Location & range'),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color: AppColors.fieldBg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.panelEdge),
          ),
          child: Row(
            children: [
              const Icon(Icons.place_outlined, size: 14, color: AppColors.stone),
              const SizedBox(width: 6),
              Expanded(
                child: TextFormField(
                  key: ValueKey(location),
                  initialValue: location,
                  onChanged: onLocationChanged,
                  style: AppFonts.inter(fontSize: 13.5),
                  decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Slider(
                min: 50,
                max: 1000,
                divisions: (1000 - 50) ~/ 25,
                value: filters.radiusKm.toDouble(),
                activeColor: AppColors.ochreDeep,
                onChanged: (v) => onFiltersChanged(filters.copyWith(radiusKm: v.round())),
              ),
            ),
            SizedBox(
              width: 62,
              child: Text(
                '${filters.radiusKm} km',
                textAlign: TextAlign.right,
                style: AppFonts.mono(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(child: _ModeButton(label: 'Simple search', active: mode == SearchMode.simple, onTap: () => onModeChanged(SearchMode.simple))),
            const SizedBox(width: 6),
            Expanded(child: _ModeButton(label: 'Advanced search', active: mode == SearchMode.advanced, onTap: () => onModeChanged(SearchMode.advanced))),
          ],
        ),
        const SizedBox(height: 18),

        const SectionLabel('Breed'),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: kBreeds
              .map((b) => SelectableChip(
                    active: filters.breeds.contains(b),
                    onTap: () => onFiltersChanged(filters.withBreedToggled(b)),
                    label: b,
                  ))
              .toList(),
        ),
        const SizedBox(height: 14),

        if (mode == SearchMode.advanced) ...[
          Row(
            children: [
              Expanded(
                child: SelectableChip(
                  active: filters.breedType == BreedType.both,
                  onTap: () => onFiltersChanged(filters.copyWith(breedType: BreedType.both)),
                  label: 'Purebred + crosses',
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: SelectableChip(
                  active: filters.breedType == BreedType.purebred,
                  onTap: () => onFiltersChanged(filters.copyWith(breedType: BreedType.purebred)),
                  label: 'Purebred only',
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: SelectableChip(
                  active: filters.breedType == BreedType.crossbred,
                  onTap: () => onFiltersChanged(filters.copyWith(breedType: BreedType.crossbred)),
                  label: 'Crossbred only',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],

        const SectionLabel('Category'),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: (mode == SearchMode.simple ? kSimpleCategories : kAllCategories)
              .map((c) => SelectableChip(
                    active: filters.categories.contains(c),
                    onTap: () => onFiltersChanged(filters.withCategoryToggled(c)),
                    label: c,
                  ))
              .toList(),
        ),
        const SizedBox(height: 20),

        const SectionLabel('Weight (kg, average liveweight)'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NumberField(
              value: filters.weightMin,
              placeholder: 'Min',
              onChanged: (v) => onFiltersChanged(filters.copyWith(weightMin: () => v)),
            ),
            const SizedBox(width: 10),
            Text('to', style: AppFonts.inter(fontSize: 13, color: AppColors.stone)),
            const SizedBox(width: 10),
            NumberField(
              value: filters.weightMax,
              placeholder: 'Max',
              onChanged: (v) => onFiltersChanged(filters.copyWith(weightMax: () => v)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ToggleRow(
          checked: filters.includeMixed,
          onChanged: (v) => onFiltersChanged(filters.copyWith(includeMixed: v)),
          label: 'Include mixed-weight mobs that partly fall outside this range',
        ),
        const SizedBox(height: 20),

        if (mode == SearchMode.advanced) ...[
          const SectionLabel('Price'),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: kPriceTypes
                .map((p) => SelectableChip(
                      active: filters.priceTypes.contains(p),
                      onTap: () => onFiltersChanged(filters.withPriceTypeToggled(p)),
                      label: p.label,
                    ))
                .toList(),
          ),
          const SizedBox(height: 10),
          ToggleRow(
            checked: filters.includePoa,
            onChanged: (v) => onFiltersChanged(filters.copyWith(includePoa: v)),
            label: 'Include listings marked price on application',
          ),
          const SizedBox(height: 20),

          const SectionLabel('Head count'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NumberField(
                value: filters.headMin,
                placeholder: 'Min',
                onChanged: (v) => onFiltersChanged(filters.copyWith(headMin: () => v)),
              ),
              const SizedBox(width: 10),
              Text('to', style: AppFonts.inter(fontSize: 13, color: AppColors.stone)),
              const SizedBox(width: 10),
              NumberField(
                value: filters.headMax,
                placeholder: 'Max',
                onChanged: (v) => onFiltersChanged(filters.copyWith(headMax: () => v)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ToggleRow(
            checked: filters.allowSplit,
            onChanged: (v) => onFiltersChanged(filters.copyWith(allowSplit: v)),
            label: 'Include larger mobs the seller is willing to split',
          ),
          const SizedBox(height: 22),
        ],

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onSearch,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ochre,
              foregroundColor: AppColors.ink,
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: Text(
              'Search cattle',
              style: AppFonts.oswald(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.3, color: AppColors.ink),
            ),
          ),
        ),
      ],
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _ModeButton({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? AppColors.ink : Colors.transparent,
      borderRadius: BorderRadius.circular(7),
      child: InkWell(
        borderRadius: BorderRadius.circular(7),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: AppColors.panelEdge),
          ),
          child: Text(
            label,
            style: AppFonts.oswald(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: active ? AppColors.bone : AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/listing.dart';
import '../models/search_filters.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/listing_card.dart';

class FeedScreen extends StatelessWidget {
  final List<Listing> results;
  final SearchFilters filters;
  final VoidCallback onEditSearch;
  final VoidCallback onSave;
  final Set<int> favourites;
  final ValueChanged<int> onToggleFavourite;
  final double freightRate;
  final ValueChanged<double> onFreightRateChanged;
  final bool hasSearched;

  const FeedScreen({
    super.key,
    required this.results,
    required this.filters,
    required this.onEditSearch,
    required this.onSave,
    required this.favourites,
    required this.onToggleFavourite,
    required this.freightRate,
    required this.onFreightRateChanged,
    required this.hasSearched,
  });

  String get _summary {
    final parts = <String>[
      filters.breeds.isNotEmpty ? filters.breeds.join(', ') : 'All breeds',
    ];
    if (filters.categories.isNotEmpty) parts.add(filters.categories.join(', '));
    if (filters.weightMin != null || filters.weightMax != null) {
      parts.add('${filters.weightMin ?? 0}–${filters.weightMax?.toString() ?? '∞'}kg');
    }
    parts.add('${filters.radiusKm}km');
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    if (!hasSearched) {
      return const EmptyState(
        title: 'No search run yet',
        body: 'Set your filters on the Search tab, or try the example search, to see matching cattle here.',
      );
    }

    return ListView(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${results.length} match${results.length == 1 ? '' : 'es'}',
                    style: AppFonts.oswald(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(_summary, style: AppFonts.inter(fontSize: 11.5, color: AppColors.stone)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            _IconTextButton(icon: Icons.tune, label: 'Edit', onTap: onEditSearch),
            const SizedBox(width: 6),
            _IconTextButton(icon: Icons.favorite_border, label: 'Save', onTap: onSave),
          ],
        ),
        const SizedBox(height: 14),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: AppColors.chipHighlight,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            children: [
              const Icon(Icons.local_shipping_outlined, size: 14, color: AppColors.ochreDeep),
              const SizedBox(width: 8),
              Text('Freight estimate rate:', style: AppFonts.inter(fontSize: 11.5, color: AppColors.ochreDeep)),
              const SizedBox(width: 6),
              SizedBox(
                width: 46,
                child: TextFormField(
                  key: ValueKey(freightRate),
                  initialValue: freightRate.toString(),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: AppFonts.mono(fontSize: 12, fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                  onChanged: (v) {
                    final parsed = double.tryParse(v);
                    if (parsed != null) onFreightRateChanged(parsed);
                  },
                ),
              ),
              Expanded(
                child: Text(
                  '\$/km — edit to match your carrier',
                  style: AppFonts.inter(fontSize: 11.5, color: AppColors.ochreDeep),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        if (results.isEmpty)
          const EmptyState(
            title: 'Nothing matches yet',
            body: 'Widen the weight range, include mixed mobs, or raise the search radius and try again.',
          )
        else
          Column(
            children: results
                .map((l) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ListingCard(
                        listing: l,
                        favoured: favourites.contains(l.id),
                        onFavourite: () => onToggleFavourite(l.id),
                        freightRate: freightRate,
                      ),
                    ))
                .toList(),
          ),
      ],
    );
  }
}

class _IconTextButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _IconTextButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.panelEdge),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 13, color: AppColors.ink),
              const SizedBox(width: 5),
              Text(label, style: AppFonts.inter(fontSize: 11.5)),
            ],
          ),
        ),
      ),
    );
  }
}

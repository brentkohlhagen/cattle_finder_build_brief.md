import 'package:flutter/material.dart';
import '../data/mock_listings.dart';
import '../models/saved_search.dart';
import '../theme/app_theme.dart';
import '../widgets/listing_card.dart';
import '../widgets/section_label.dart';

class SavedScreen extends StatelessWidget {
  final List<SavedSearch> savedSearches;
  final ValueChanged<SavedSearch> onRun;
  final ValueChanged<int> onRemove;
  final Set<int> favourites;
  final ValueChanged<int> onToggleFavourite;
  final double freightRate;

  const SavedScreen({
    super.key,
    required this.savedSearches,
    required this.onRun,
    required this.onRemove,
    required this.favourites,
    required this.onToggleFavourite,
    required this.freightRate,
  });

  @override
  Widget build(BuildContext context) {
    final favouredListings = mockListings.where((l) => favourites.contains(l.id)).toList();

    return ListView(
      children: [
        const SectionLabel('Saved searches'),
        if (savedSearches.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: Text(
              'Save a search from the Feed tab to get alerts when new cattle match it.',
              style: AppFonts.inter(fontSize: 12.5, color: AppColors.stone),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: Column(
              children: savedSearches
                  .map((s) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
                        decoration: BoxDecoration(
                          color: AppColors.fieldBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.panelEdge),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => onRun(s),
                                child: Text(s.label, style: AppFonts.inter(fontSize: 12.5)),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => onRemove(s.id),
                              child: const Icon(Icons.delete_outline, size: 16, color: AppColors.stone),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        const SectionLabel('Favourited listings'),
        if (favouredListings.isEmpty)
          Text(
            'Tap the heart on a listing in the Feed to keep it here.',
            style: AppFonts.inter(fontSize: 12.5, color: AppColors.stone),
          )
        else
          Column(
            children: favouredListings
                .map((l) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ListingCard(
                        listing: l,
                        favoured: true,
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

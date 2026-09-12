import 'package:flutter/material.dart';
import '../models/filter_logic.dart';
import '../models/format.dart';
import '../models/listing.dart';
import '../theme/app_theme.dart';
import 'mono_stat.dart';

class ListingCard extends StatelessWidget {
  final Listing listing;
  final bool favoured;
  final VoidCallback onFavourite;
  final double freightRate;

  const ListingCard({
    super.key,
    required this.listing,
    required this.favoured,
    required this.onFavourite,
    required this.freightRate,
  });

  String get _weightLine {
    if (listing.avgWeight != null) return 'avg ${listing.avgWeight}kg';
    if (listing.weightRange != null) {
      return '${listing.weightRange!.low}–${listing.weightRange!.high}kg';
    }
    return 'weight not listed';
  }

  String _priceLine() {
    if (listing.priceType == PriceType.poa) return 'POA';
    if (listing.priceType == PriceType.perHead) {
      return '\$${fmtMoney(listing.price ?? 0)}';
    }
    return '${fmtMoney(listing.price ?? 0)} ${listing.priceType.label}';
  }

  @override
  Widget build(BuildContext context) {
    final landed = landedPerHead(listing, freightRate);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.panelEdge),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 5,
              color: listing.trusted ? AppColors.sage : AppColors.rust,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            '${listing.head} ${listing.breed}${listing.cross ? ' X' : ''} ${listing.category}',
                            style: AppFonts.oswald(fontSize: 14.5, fontWeight: FontWeight.w600),
                          ),
                        ),
                        GestureDetector(
                          onTap: onFavourite,
                          child: Icon(
                            favoured ? Icons.favorite : Icons.favorite_border,
                            size: 17,
                            color: favoured ? AppColors.rust : AppColors.boneDim,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 10,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        MonoStat(label: 'Weight', value: _weightLine),
                        if (listing.mixed)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.chipHighlight,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'Mixed weight',
                              style: AppFonts.inter(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ochreDeep,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        MonoStat(label: 'Price', value: _priceLine()),
                        MonoStat(
                          label: 'Freight est.',
                          value: '\$${landed.freightPerHead.toStringAsFixed(0)}/hd',
                        ),
                        if (landed.landed != null)
                          MonoStat(
                            label: 'Landed est.',
                            value: '\$${fmtMoney(landed.landed!)}/hd',
                          ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Container(
                      padding: const EdgeInsets.only(top: 8),
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: AppColors.panelEdge)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(Icons.place_outlined, size: 11, color: AppColors.stone),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '${listing.location} · ${listing.distance}km',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppFonts.inter(fontSize: 11, color: AppColors.stone),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                listing.trusted ? Icons.verified_outlined : Icons.schedule_outlined,
                                size: 12,
                                color: listing.trusted ? AppColors.sage : AppColors.rust,
                              ),
                              const SizedBox(width: 4),
                              Text(listing.source, style: AppFonts.inter(fontSize: 11, color: AppColors.stone)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.link, size: 12, color: AppColors.ochreDeep),
                        const SizedBox(width: 4),
                        Text(
                          'View original listing',
                          style: AppFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.ochreDeep),
                        ),
                        const Icon(Icons.chevron_right, size: 12, color: AppColors.ochreDeep),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'listing.dart';
import 'search_filters.dart';

/// Whether [listing] satisfies [filters].
///
/// Ported from the validated web prototype's `matchesFilters`, including the
/// weight-overlap rule for mixed mobs and the split-mob rule for head count:
/// a mob whose weight range only partly overlaps the requested band is
/// included (flagged, not excluded) when `includeMixed` is on, and a mob
/// above the head-count max is included when `allowSplit` is on and the
/// seller has marked it splittable.
bool matchesFilters(Listing listing, SearchFilters filters) {
  if (filters.breeds.isNotEmpty) {
    if (!filters.breeds.contains(listing.breed)) return false;
    if (filters.breedType == BreedType.purebred && listing.cross) {
      return false;
    }
    if (filters.breedType == BreedType.crossbred && !listing.cross) {
      return false;
    }
  }

  if (filters.categories.isNotEmpty &&
      !filters.categories.contains(listing.category)) {
    return false;
  }

  final min = filters.weightMin;
  final max = filters.weightMax;
  if (min != null || max != null) {
    if (listing.avgWeight != null) {
      final okMin = min == null || listing.avgWeight! >= min;
      final okMax = max == null || listing.avgWeight! <= max;
      if (!(okMin && okMax)) return false;
    } else if (listing.weightRange != null) {
      final lo = listing.weightRange!.low;
      final hi = listing.weightRange!.high;
      final overlaps = (min == null || hi >= min) && (max == null || lo <= max);
      final fullyInside = (min == null || lo >= min) && (max == null || hi <= max);
      if (!fullyInside) {
        if (!(filters.includeMixed && overlaps)) return false;
      }
    }
  }

  if (filters.priceTypes.isNotEmpty) {
    if (listing.priceType == PriceType.poa) {
      if (!filters.includePoa) return false;
    } else if (!filters.priceTypes.contains(listing.priceType)) {
      return false;
    }
  }

  if (listing.distance > filters.radiusKm) return false;

  final hMin = filters.headMin;
  final hMax = filters.headMax;
  if (hMin != null && listing.head < hMin) return false;
  if (hMax != null && listing.head > hMax) {
    if (!(filters.allowSplit && listing.splittable)) return false;
  }

  return true;
}

/// Per-head freight estimate and landed cost for [listing] at [freightRate]
/// ($/km, split across the mob). Landed cost is null when the listing has no
/// derivable per-head price (POA, or priced in c/kg dressed weight, which
/// can't be converted to a liveweight-based landed cost without a dressing
/// percentage).
class LandedCost {
  final double freightPerHead;
  final double? landed;

  const LandedCost({required this.freightPerHead, this.landed});
}

LandedCost landedPerHead(Listing listing, double freightRate) {
  final freightPerHead = (listing.distance * freightRate) / listing.head;

  double? base;
  if (listing.priceType == PriceType.perHead) {
    base = listing.price?.toDouble();
  } else if (listing.priceType == PriceType.centsPerKgLiveweight) {
    final w = listing.avgWeight?.toDouble() ??
        (listing.weightRange != null
            ? (listing.weightRange!.low + listing.weightRange!.high) / 2
            : null);
    if (w != null && listing.price != null) {
      base = (listing.price! / 100) * w;
    }
  }

  return LandedCost(
    freightPerHead: freightPerHead,
    landed: base != null ? base + freightPerHead : null,
  );
}

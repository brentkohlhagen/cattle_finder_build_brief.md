/// A weight range for a mob whose animals aren't a uniform weight
/// (e.g. a drafted pen quoted as "350-410kg" rather than a single average).
class WeightRange {
  final int low;
  final int high;

  const WeightRange(this.low, this.high);
}

enum PriceType {
  perHead('\$/head'),
  centsPerKgLiveweight('c/kg lwt'),
  centsPerKgDressed('c/kg dwt'),
  poa('POA');

  final String label;
  const PriceType(this.label);
}

/// A single sale listing, standing in for a feed from AuctionsPlus / TopX /
/// Nutrien / Ray White Rural / GDL or a farmer-submitted link.
class Listing {
  final int id;
  final String breed;
  final bool cross;
  final String category;
  final int head;

  /// Average liveweight in kg, when the listing quotes a single figure.
  final int? avgWeight;

  /// Weight range in kg, when the mob is a mixed-weight draft rather than
  /// a single average (mutually exclusive with [avgWeight] in practice).
  final WeightRange? weightRange;

  /// True when the mob spans a range of weights rather than being uniform.
  final bool mixed;
  final PriceType priceType;

  /// Null when [priceType] is [PriceType.poa].
  final int? price;
  final String location;

  /// Straight-line distance in km from the farmer's search location.
  final int distance;
  final String saleDate;
  final String source;

  /// Trusted sources/agents publish automatically; untrusted ones (e.g.
  /// farmer-submitted) sit in an admin review queue until confirmed.
  final bool trusted;

  /// Whether the seller will split this mob for buyers under the head count.
  final bool splittable;

  const Listing({
    required this.id,
    required this.breed,
    required this.cross,
    required this.category,
    required this.head,
    this.avgWeight,
    this.weightRange,
    required this.mixed,
    required this.priceType,
    this.price,
    required this.location,
    required this.distance,
    required this.saleDate,
    required this.source,
    required this.trusted,
    required this.splittable,
  });
}

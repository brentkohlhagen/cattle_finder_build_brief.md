import 'listing.dart';

enum BreedType { purebred, crossbred, both }

const List<String> kBreeds = [
  'Speckle Park',
  'Angus',
  'Brahman',
  'Charolais',
  'Hereford',
  'Droughtmaster',
  'Wagyu',
  'Santa Gertrudis',
  'Simmental',
];

const List<String> kSimpleCategories = ['Steers', 'Heifers', 'Cows', 'Bulls'];

const List<String> kAllCategories = [
  'Steers',
  'Heifers',
  'Cows',
  'Bulls',
  'PTIC Heifers',
  'Cows & Calves',
  'Weaners',
  'Feeders',
  'Breeders',
  'Mixed Mob',
];

const List<PriceType> kPriceTypes = [
  PriceType.perHead,
  PriceType.centsPerKgLiveweight,
  PriceType.centsPerKgDressed,
];

/// Search/alert filters. Immutable; use [copyWith] to change a value.
class SearchFilters {
  final List<String> breeds;
  final BreedType breedType;
  final List<String> categories;
  final int? weightMin;
  final int? weightMax;
  final bool includeMixed;
  final List<PriceType> priceTypes;
  final bool includePoa;
  final int radiusKm;
  final int? headMin;
  final int? headMax;
  final bool allowSplit;

  const SearchFilters({
    this.breeds = const [],
    this.breedType = BreedType.both,
    this.categories = const [],
    this.weightMin,
    this.weightMax,
    this.includeMixed = true,
    this.priceTypes = const [],
    this.includePoa = true,
    this.radiusKm = 700,
    this.headMin,
    this.headMax,
    this.allowSplit = true,
  });

  static const empty = SearchFilters();

  /// The "Try an example" search: Speckle Park, purebred or cross, 320kg+,
  /// within 700km.
  static final example = SearchFilters(
    breeds: const ['Speckle Park'],
    breedType: BreedType.both,
    categories: const ['Steers', 'Heifers', 'Feeders'],
    weightMin: 320,
    includeMixed: true,
    radiusKm: 700,
  );

  SearchFilters copyWith({
    List<String>? breeds,
    BreedType? breedType,
    List<String>? categories,
    int? Function()? weightMin,
    int? Function()? weightMax,
    bool? includeMixed,
    List<PriceType>? priceTypes,
    bool? includePoa,
    int? radiusKm,
    int? Function()? headMin,
    int? Function()? headMax,
    bool? allowSplit,
  }) {
    return SearchFilters(
      breeds: breeds ?? this.breeds,
      breedType: breedType ?? this.breedType,
      categories: categories ?? this.categories,
      weightMin: weightMin != null ? weightMin() : this.weightMin,
      weightMax: weightMax != null ? weightMax() : this.weightMax,
      includeMixed: includeMixed ?? this.includeMixed,
      priceTypes: priceTypes ?? this.priceTypes,
      includePoa: includePoa ?? this.includePoa,
      radiusKm: radiusKm ?? this.radiusKm,
      headMin: headMin != null ? headMin() : this.headMin,
      headMax: headMax != null ? headMax() : this.headMax,
      allowSplit: allowSplit ?? this.allowSplit,
    );
  }

  SearchFilters withBreedToggled(String breed) {
    final next = List<String>.from(breeds);
    next.contains(breed) ? next.remove(breed) : next.add(breed);
    return copyWith(breeds: next);
  }

  SearchFilters withCategoryToggled(String category) {
    final next = List<String>.from(categories);
    next.contains(category) ? next.remove(category) : next.add(category);
    return copyWith(categories: next);
  }

  SearchFilters withPriceTypeToggled(PriceType type) {
    final next = List<PriceType>.from(priceTypes);
    next.contains(type) ? next.remove(type) : next.add(type);
    return copyWith(priceTypes: next);
  }
}

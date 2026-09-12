import 'package:cattle_finder/data/mock_listings.dart';
import 'package:cattle_finder/models/filter_logic.dart';
import 'package:cattle_finder/models/listing.dart';
import 'package:cattle_finder/models/search_filters.dart';
import 'package:flutter_test/flutter_test.dart';

Listing _speckleCross({
  required String category,
  int? avgWeight,
  WeightRange? weightRange,
}) {
  return Listing(
    id: 999,
    breed: 'Speckle Park',
    cross: true,
    category: category,
    head: 40,
    avgWeight: avgWeight,
    weightRange: weightRange,
    mixed: weightRange != null,
    priceType: PriceType.perHead,
    price: 1500,
    location: 'Test, QLD',
    distance: 100,
    saleDate: '1 Jan',
    source: 'AuctionsPlus',
    trusted: true,
    splittable: false,
  );
}

void main() {
  group('build brief acceptance test — Speckle Park + cross, 320kg+', () {
    final filters = SearchFilters(
      breeds: const ['Speckle Park'],
      breedType: BreedType.crossbred,
      weightMin: 320,
      includeMixed: true,
    );

    test('a 280-380kg mixed-weight mob appears (overlaps the band)', () {
      final mob = _speckleCross(
        category: 'Feeders',
        weightRange: const WeightRange(280, 380),
      );
      expect(matchesFilters(mob, filters), isTrue);
      expect(mob.mixed, isTrue, reason: 'should be flagged mixed-weight in the UI');
    });

    test('a 250-300kg mob is excluded (does not overlap 320kg+)', () {
      final mob = _speckleCross(
        category: 'Feeders',
        weightRange: const WeightRange(250, 300),
      );
      expect(matchesFilters(mob, filters), isFalse);
    });

    test('the overlapping mob is excluded once includeMixed is off', () {
      final withoutMixed = filters.copyWith(includeMixed: false);
      final mob = _speckleCross(
        category: 'Feeders',
        weightRange: const WeightRange(280, 380),
      );
      expect(matchesFilters(mob, withoutMixed), isFalse);
    });
  });

  group('breed + breed-type filtering', () {
    test('no breeds selected matches everything', () {
      expect(matchesFilters(mockListings[0], SearchFilters.empty), isTrue);
    });

    test('purebred-only excludes a crossbred listing of the selected breed', () {
      final filters = SearchFilters(
        breeds: const ['Speckle Park'],
        breedType: BreedType.purebred,
      );
      final crossListing = mockListings.firstWhere((l) => l.id == 1);
      expect(crossListing.cross, isTrue);
      expect(matchesFilters(crossListing, filters), isFalse);
    });

    test('crossbred-only excludes a purebred listing of the selected breed', () {
      final filters = SearchFilters(
        breeds: const ['Speckle Park'],
        breedType: BreedType.crossbred,
      );
      final pureListing = mockListings.firstWhere((l) => l.id == 2);
      expect(pureListing.cross, isFalse);
      expect(matchesFilters(pureListing, filters), isFalse);
    });
  });

  group('weight filtering — uniform (avgWeight) listings', () {
    test('a listing below the minimum is excluded outright, mixed or not', () {
      final filters = SearchFilters(weightMin: 400, includeMixed: true);
      final listing = mockListings.firstWhere((l) => l.id == 2); // avg 347
      expect(matchesFilters(listing, filters), isFalse);
    });
  });

  group('price filtering', () {
    test('POA is excluded once includePoa is off', () {
      final filters = SearchFilters(
        priceTypes: const [PriceType.perHead],
        includePoa: false,
      );
      final poaListing = mockListings.firstWhere((l) => l.priceType == PriceType.poa);
      expect(matchesFilters(poaListing, filters), isFalse);
    });

    test('POA is included when includePoa is on, regardless of priceTypes', () {
      final filters = SearchFilters(
        priceTypes: const [PriceType.perHead],
        includePoa: true,
      );
      final poaListing = mockListings.firstWhere((l) => l.priceType == PriceType.poa);
      expect(matchesFilters(poaListing, filters), isTrue);
    });
  });

  group('head count + split-mob filtering', () {
    test('a mob over the max is excluded when not splittable', () {
      final filters = SearchFilters(headMax: 50, allowSplit: true);
      final over = mockListings.firstWhere((l) => l.id == 6); // 96 head, splittable
      final overNotSplittable = mockListings.firstWhere((l) => l.id == 3); // 42 head fits anyway
      expect(matchesFilters(over, filters), isTrue, reason: 'splittable mob over max should be included');
      expect(overNotSplittable.head <= 50, isTrue);
    });

    test('a mob over the max is excluded when allowSplit is off', () {
      final filters = SearchFilters(headMax: 50, allowSplit: false);
      final over = mockListings.firstWhere((l) => l.id == 6); // 96 head, splittable
      expect(matchesFilters(over, filters), isFalse);
    });
  });

  group('radius filtering', () {
    test('a listing beyond the radius is excluded', () {
      final filters = SearchFilters(radiusKm: 100);
      final farListing = mockListings.firstWhere((l) => l.distance > 100);
      expect(matchesFilters(farListing, filters), isFalse);
    });
  });

  group('landedPerHead', () {
    test('computes freight and landed cost for a \$/head listing', () {
      final listing = mockListings.firstWhere((l) => l.id == 2); // 1490 $/head, 510km, 18 head
      final result = landedPerHead(listing, 3.2);
      expect(result.freightPerHead, closeTo(510 * 3.2 / 18, 0.01));
      expect(result.landed, closeTo(1490 + result.freightPerHead, 0.01));
    });

    test('derives base price from avgWeight for a c/kg lwt listing', () {
      final listing = mockListings.firstWhere((l) => l.id == 1); // 435 c/kg, avg 382kg
      final result = landedPerHead(listing, 3.2);
      final expectedBase = (435 / 100) * 382;
      expect(result.landed, closeTo(expectedBase + result.freightPerHead, 0.01));
    });

    test('falls back to the weight-range midpoint when avgWeight is absent', () {
      final listing = mockListings.firstWhere((l) => l.id == 6); // 398 c/kg, range 380-480
      final result = landedPerHead(listing, 3.2);
      final expectedBase = (398 / 100) * 430; // midpoint of 380-480
      expect(result.landed, closeTo(expectedBase + result.freightPerHead, 0.01));
    });

    test('landed cost is null for POA listings', () {
      final listing = mockListings.firstWhere((l) => l.priceType == PriceType.poa);
      final result = landedPerHead(listing, 3.2);
      expect(result.landed, isNull);
    });

    test('landed cost is null for c/kg dressed-weight listings', () {
      final listing = mockListings.firstWhere((l) => l.priceType == PriceType.centsPerKgDressed);
      final result = landedPerHead(listing, 3.2);
      expect(result.landed, isNull);
    });
  });
}

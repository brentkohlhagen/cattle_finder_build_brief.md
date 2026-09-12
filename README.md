# Cattle Finder

A Flutter (iOS + Android) phone-search prototype for Australian farmers to find cattle
for sale across multiple sale sources. This is the first development milestone from
`docs/build_brief.md`: simple/advanced search, breed/category/weight/price/head-count
filtering (including mixed-weight-mob and split-mob logic), a results feed with
freight/landed-cost estimates, favourites, saved searches, and a farmer listing-submission
form — all running against a mock dataset until a live source's access terms are confirmed.

The filter logic (weight-overlap, split-mob, freight/landed-cost) is ported from the
validated `cattle_finder_prototype.jsx` React prototype referenced in the build brief.

## Running it

```
flutter pub get
flutter run
```

## Testing

```
flutter analyze
flutter test
```

`test/filter_logic_test.dart` covers the filter/pricing logic directly, including the
build brief's stated acceptance test: searching Speckle Park + cross, 320kg+, a
280–380kg mixed-weight mob is included and flagged, while a 250–300kg mob is excluded.
`test/app_smoke_test.dart` exercises the golden path through the actual UI (search →
feed, the example search, tab navigation).

## Project layout

- `lib/models/` — `Listing`, `SearchFilters`, `SavedSearch`, and the pure filter/pricing
  functions (`matchesFilters`, `landedPerHead`)
- `lib/data/mock_listings.dart` — seed dataset standing in for AuctionsPlus/TopX/Nutrien/
  Ray White Rural/GDL feeds and farmer-submitted links
- `lib/screens/` — Search, Feed, Saved and Submit tabs, plus `home_shell.dart` which owns
  app state
- `lib/widgets/` — shared UI atoms (chips, toggles, listing card, etc.)
- `lib/theme/` — the ink/ochre/rust palette and type system carried over from the
  prototype

## Status / what's not built yet

Per the build brief, no live sale sources are connected — every source (AuctionsPlus,
TopX, Nutrien, Ray White Rural, GDL) stays inactive until an official API/data
partnership, a permitted feed/alert mechanism, or farmer-submitted links are confirmed.
Also not in this milestone: Supabase auth/accounts, saved-search sync, Firebase push
alerts, email alerts, and real road-distance/freight calculation (straight-line distance
and an editable flat $/km rate stand in for now).

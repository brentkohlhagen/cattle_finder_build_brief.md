import 'search_filters.dart';

class SavedSearch {
  final int id;
  final String label;
  final SearchFilters filters;

  const SavedSearch({
    required this.id,
    required this.label,
    required this.filters,
  });
}

import 'package:flutter/material.dart';
import '../data/mock_listings.dart';
import '../models/filter_logic.dart';
import '../models/listing.dart';
import '../models/saved_search.dart';
import '../models/search_filters.dart';
import '../theme/app_theme.dart';
import 'feed_screen.dart';
import 'saved_screen.dart';
import 'search_screen.dart';
import 'submit_screen.dart';

enum _Tab { search, feed, saved, submit }

/// Owns all app-level state and passes it down to the four tab screens, the
/// same "lift state to the top" shape as the web prototype's root component.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  _Tab _tab = _Tab.search;
  SearchMode _mode = SearchMode.simple;
  SearchFilters _filters = SearchFilters.empty;
  String _location = 'Harlin, QLD';
  double _freightRate = 3.2;
  final Set<int> _favourites = {};
  final List<SavedSearch> _savedSearches = [];
  String _submitUrl = '';
  String? _submitBreed;
  bool _hasSearched = false;

  List<Listing> get _results =>
      mockListings.where((l) => matchesFilters(l, _filters)).toList();

  void _runSearch() {
    setState(() {
      _hasSearched = true;
      _tab = _Tab.feed;
    });
  }

  void _loadExample() {
    setState(() {
      _filters = SearchFilters.example;
      _hasSearched = true;
      _mode = SearchMode.advanced;
      _tab = _Tab.feed;
    });
  }

  void _toggleFavourite(int id) {
    setState(() {
      _favourites.contains(id) ? _favourites.remove(id) : _favourites.add(id);
    });
  }

  void _flashToast(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppFonts.inter(fontSize: 13.5, color: AppColors.bone)),
        backgroundColor: AppColors.ink,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 2200),
      ),
    );
  }

  void _saveCurrentSearch() {
    final label = (_filters.breeds.isNotEmpty ? _filters.breeds.first : 'All breeds') +
        (_filters.categories.isNotEmpty ? ' · ${_filters.categories.join('/')}' : '');
    setState(() {
      _savedSearches.insert(
        0,
        SavedSearch(id: DateTime.now().millisecondsSinceEpoch, label: label, filters: _filters),
      );
    });
    _flashToast('Search saved');
  }

  void _runSavedSearch(SavedSearch s) {
    setState(() {
      _filters = s.filters;
      _tab = _Tab.feed;
    });
  }

  void _removeSavedSearch(int id) {
    setState(() => _savedSearches.removeWhere((s) => s.id == id));
  }

  void _submitListing() {
    if (_submitUrl.trim().isEmpty) return;
    _flashToast('Sent for review');
    setState(() {
      _submitUrl = '';
      _submitBreed = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Scaffold(
      backgroundColor: AppColors.panel,
      appBar: AppBar(
        backgroundColor: AppColors.ink,
        elevation: 0,
        titleSpacing: 16,
        title: Text(
          'Cattle Finder',
          style: AppFonts.oswald(fontSize: 21, fontWeight: FontWeight.w700, color: AppColors.bone, letterSpacing: 0.3),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(_location, style: AppFonts.mono(fontSize: 11.5, color: AppColors.boneDim)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: IndexedStack(
            index: _Tab.values.indexOf(_tab),
            children: [
              SearchScreen(
                mode: _mode,
                onModeChanged: (m) => setState(() => _mode = m),
                filters: _filters,
                onFiltersChanged: (f) => setState(() => _filters = f),
                location: _location,
                onLocationChanged: (v) => setState(() => _location = v),
                onSearch: _runSearch,
                onExample: _loadExample,
              ),
              FeedScreen(
                results: results,
                filters: _filters,
                onEditSearch: () => setState(() => _tab = _Tab.search),
                onSave: _saveCurrentSearch,
                favourites: _favourites,
                onToggleFavourite: _toggleFavourite,
                freightRate: _freightRate,
                onFreightRateChanged: (v) => setState(() => _freightRate = v),
                hasSearched: _hasSearched,
              ),
              SavedScreen(
                savedSearches: _savedSearches,
                onRun: _runSavedSearch,
                onRemove: _removeSavedSearch,
                favourites: _favourites,
                onToggleFavourite: _toggleFavourite,
                freightRate: _freightRate,
              ),
              SubmitScreen(
                submitUrl: _submitUrl,
                onSubmitUrlChanged: (v) => setState(() => _submitUrl = v),
                submitBreed: _submitBreed,
                onSubmitBreedChanged: (v) => setState(() => _submitBreed = v),
                onSubmit: _submitListing,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _Tab.values.indexOf(_tab),
        onTap: (i) => setState(() => _tab = _Tab.values[i]),
        backgroundColor: AppColors.ink,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.ochre,
        unselectedItemColor: AppColors.boneDim,
        selectedLabelStyle: AppFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w500),
        unselectedLabelStyle: AppFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w500),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_list),
            label: _hasSearched ? 'Feed (${results.length})' : 'Feed',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite_border),
            label: _favourites.isNotEmpty ? 'Saved (${_favourites.length})' : 'Saved',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Submit'),
        ],
      ),
    );
  }
}

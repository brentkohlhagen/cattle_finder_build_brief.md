import 'package:cattle_finder/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('search -> feed golden path shows results and nav updates', (tester) async {
    await tester.pumpWidget(const CattleFinderApp());

    expect(find.text('Cattle Finder'), findsOneWidget);
    expect(find.text('No search run yet'), findsNothing); // Search tab is shown first, not Feed.

    final searchButton = find.text('Search cattle');
    await tester.scrollUntilVisible(searchButton, 200, scrollable: find.byType(Scrollable).first);
    await tester.tap(searchButton);
    await tester.pumpAndSettle();

    // Landed on Feed after a plain search with no filters set: every mock
    // listing matches (breeds/categories empty, default 700km radius).
    expect(find.textContaining('matches'), findsOneWidget);
    expect(find.text('Nothing matches yet'), findsNothing);
  });

  testWidgets('the example search surfaces a flagged mixed-weight mob', (tester) async {
    await tester.pumpWidget(const CattleFinderApp());

    await tester.tap(find.textContaining('Try an example'));
    await tester.pumpAndSettle();

    // The example search is Speckle Park, 320kg+, 700km — listing #1 (a
    // 350-410kg mixed mob averaging 382kg) should appear and be flagged.
    expect(find.textContaining('matches'), findsOneWidget);
    expect(find.text('Mixed weight'), findsWidgets);
  });

  testWidgets('bottom nav switches tabs', (tester) async {
    await tester.pumpWidget(const CattleFinderApp());

    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
    expect(find.text('Submit a listing'), findsOneWidget);

    await tester.tap(find.text('Saved'));
    await tester.pumpAndSettle();
    expect(find.text('Saved searches'), findsOneWidget);
  });
}

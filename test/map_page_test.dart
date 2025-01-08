import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getnextframe_bug_demo/listings.dart';
import 'package:getnextframe_bug_demo/map_page.dart';

void main() async {
  listings = [
    {
      'displayName': 'Glazed and Confused',
      'endTime': '16:30',
      'id': '1',
      'phone': '01223 111111',
      'latLng': '52.199687,0.138813',
      'primaryType': 'Food',
      'secondaryType': 'Food',
      'startTime': '10:30',
      'tertiaryType': 'Doughnuts',
      'website': 'https://www.glazedandconfused.com',
    }
  ];

  // Set up mocks
  late MapPageState mapPageState;
  setUp(() {
    mapPageState = MapPage(listings: listings).createState();
  });

  testWidgets('Does the map marker exist?', (WidgetTester tester) async {
    // Build the MapPage widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MapPage(listings: listings),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final mapPageState = tester.state(find.byType(MapPage)) as MapPageState;

    // Verify that the expected marker was added
    expect(mapPageState.markers.isNotEmpty, true);
    expect(mapPageState.markers.length, 1);
  });
}

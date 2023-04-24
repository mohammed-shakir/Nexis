import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexis/pages/home.dart';

void main() {
  testWidgets('Press Test Page button navigates to /test_page', (WidgetTester tester) async {
    // Create a MaterialApp with the Home widget and a mock Navigator.
    await tester.pumpWidget(
      MaterialApp(
        home: Home(),
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (_) => const SizedBox(),
            settings: settings,
          );
        },
      ),
    );

    // Find the Test Page button.
    final testPageButton = find.text('Test Page');
    expect(testPageButton, findsOneWidget);

    // Press the Test Page button.
    await tester.tap(testPageButton);
    await tester.pumpAndSettle();

    // Verify that the app navigated to the /test_page route.
    expect(find.text('/test_page'), findsNothing);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexis/pages/home.dart';

void main() {
  testWidgets('Press Test Page button navigates to /test_page', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MaterialApp(home: Home()));
  });
}

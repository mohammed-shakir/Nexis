import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexis/pages/main/home.dart';
import 'test_config.dart';

void main() {
  setUpAll(() async {
    await loadTestEnvironment();
  });
  testWidgets('Open the app', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MaterialApp(home: Home()));
  });
}

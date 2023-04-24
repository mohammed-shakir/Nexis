import 'package:flutter_test/flutter_test.dart';
import 'package:nexis/main.dart';

void main() {
  testWidgets('App runs', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Nexis());
  });
}

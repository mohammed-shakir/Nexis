import 'package:flutter_test/flutter_test.dart';
import 'package:nexis/main.dart';

void main() {
  testWidgets('Init test', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const Nexis());
  });
}

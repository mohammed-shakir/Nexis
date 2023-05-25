import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexis/main.dart';

void main() {
  group('Init test', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      FirebaseFirestore.instance.settings = const Settings(
        host: 'localhost:8080', // Use the URL of the Firestore emulator
        sslEnabled: false,
        persistenceEnabled: false,
      );
    });

    testWidgets('Renders entire app', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const Nexis());
    });
  });
}

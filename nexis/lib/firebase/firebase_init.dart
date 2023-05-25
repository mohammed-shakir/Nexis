import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:firedart/firedart.dart';
import 'package:nexis/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> initializeFirebase() async {
  try {
    await dotenv.load(fileName: ".env");

    if (kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else if (Platform.isWindows || Platform.isLinux) {
      FirebaseAuth.initialize(dotenv.env['FIREBASE_API_KEY']!, VolatileStore());
      Firestore.initialize(dotenv.env['FIREBASE_PROJECT_ID']!);
    }
  } catch (e) {
    throw Exception('Failed to initialize Firebase: $e');
  }
}

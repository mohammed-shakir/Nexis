import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firedart/firedart.dart';
import 'package:nexis/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/home.dart';
import 'pages/settings/settings_page.dart';
import 'themes/default_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  var logger = Logger();

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      FirebaseAuth.initialize(dotenv.env['FIREBASE_API_KEY']!, VolatileStore());
      Firestore.initialize(dotenv.env['FIREBASE_PROJECT_ID']!);
    }
  } catch (e) {
    logger.e('Failed to initialize Firebase: $e');
  }

  runApp(const Nexis());
}

class Nexis extends StatelessWidget {
  const Nexis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexis',
      theme: appTheme,
      initialRoute: '/home',
      // remove debug banner
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => const Home(),
        '/settings_page': (context) => const SettingsPage(),
      },
    );
  }
}

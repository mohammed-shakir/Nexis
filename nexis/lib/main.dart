import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firedart/firedart.dart';
import 'pages/home.dart';
import 'pages/test_page.dart';
import 'pages/auth_page.dart';
import 'src/theme.dart';

const apiKey = 'AIzaSyCoLcjf9pJLSwCF0zBXq-0-_aYxx8cF7sI';
const projectId = 'nexis-4723a';

Future<void> main() async {
  // await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    Firestore.initialize(projectId);
  } catch (e) {
    print('Failed to initialize Firebase: $e');
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
      routes: {
        '/home': (context) => const Home(),
        '/test_page': (context) => const TestPage(),
        '/auth_page': (context) => AuthPage(),
      },
    );
  }
}

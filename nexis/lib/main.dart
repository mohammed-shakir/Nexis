import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/home.dart';
import 'pages/test_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }

  runApp(const Nexis());
}

class Nexis extends StatelessWidget {
  const Nexis({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexis',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/test_page': (context) => const TestPage(),
      },
    );
  }
}

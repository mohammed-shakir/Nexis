import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/home.dart';
import 'pages/test_page.dart';
import 'pages/auth_page.dart';
import 'src/auth.dart';

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
    final auth = Auth();
    return MaterialApp(
      title: 'Nexis',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data == null) {
              // User is not logged in, show the GoogleAuth page
              return const GoogleAuth();
            } else {
              // User is logged in, show the Home page
              return Home();
            }
          } else {
            // Show a loading indicator while waiting for the auth state
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
      routes: {
        '/test_page': (context) => const TestPage(),
        '/auth_page': (context) => const GoogleAuth(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nexis/src/auth.dart';

class GoogleAuth extends StatefulWidget {
  const GoogleAuth({Key? key}) : super(key: key);

  @override
  _GoogleAuthState createState() => _GoogleAuthState();
}

class _GoogleAuthState extends State<GoogleAuth> {
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Auth'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: () async {
                final user = await _auth.signInWithGoogle();
                if (user != null) {
                  Navigator.pushNamed(context, '/test_page');
                } else {
                  print("Failed to sign in with Google");
                }
              },
              icon: const Icon(Icons.login),
              label: const Text('Sign in with Google'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                final user = await _auth.registerWithGoogle();
                if (user != null) {
                  Navigator.of(context)
                      .pop(); // Navigate back to the previous page
                } else {
                  print("Failed to register with Google");
                }
              },
              icon: const Icon(Icons.app_registration),
              label: const Text('Register with Google'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nexis/src/auth.dart';
import 'package:nexis/widgets/custom_button.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomButton(
              text: 'Sign in with Google',
              onPressed: () {
                print("Sign in with Google");
              },
            ),
          ],
        ),
      ),
    );
  }
}

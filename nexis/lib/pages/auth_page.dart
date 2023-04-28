import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nexis/widgets/custom_button.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  var logger = Logger();

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
                logger.i("Sign in with Google");
              },
            ),
          ],
        ),
      ),
    );
  }
}

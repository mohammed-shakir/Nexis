import 'package:flutter/material.dart';
import '../src/widgets.dart';
import '../src/auth.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CustomText(
              text: 'Nexis',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            CustomButton(
              text: 'Test Page',
              onPressed: () {
                Navigator.pushNamed(context, '/test_page');
                // print('Go to Test Page');
              },
              textStyle: const TextStyle(
                color: Colors.black,
              ),
            ),
            CustomButton(
              text: 'Logout',
              onPressed: () async {
                await _auth.signOut();
                // print('Go to Test Page');
              },
              textStyle: const TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

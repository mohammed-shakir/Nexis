import 'package:flutter/material.dart';
import '../src/widgets.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CustomText(
              text: 'Test Page',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            CustomButton(
              text: 'Go Back',
              onPressed: () {
                Navigator.pushNamed(context, '/');
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

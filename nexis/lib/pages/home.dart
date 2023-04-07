import 'package:flutter/material.dart';
import '../src/widgets.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
              text: 'Nexis',
              onPressed: () {
                Navigator.pushNamed(context, '/test_page');
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

import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171c2a),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Why are u gae?',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Arial',
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Back',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

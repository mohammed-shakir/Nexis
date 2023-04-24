import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Test Page',
              style: Theme.of(context).textTheme.displayMedium,
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

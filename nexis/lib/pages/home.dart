import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nexis',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Test Page',
              onPressed: () {
                Navigator.pushNamed(context, '/test_page');
              },
            ),
          ],
        ),
      ),
    );
  }
}

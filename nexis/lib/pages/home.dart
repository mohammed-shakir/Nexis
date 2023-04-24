import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import 'package:firedart/firedart.dart';

const projectId = '';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171c2a),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Nexis',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Arial',
                fontSize: 24,
              ),
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

import 'package:flutter/material.dart';

class OfflinePage extends StatelessWidget {
  const OfflinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'This is the Offline Page',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}

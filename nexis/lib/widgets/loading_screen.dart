import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;

  final List<String> loadingPhrases = [
    'Loading the magic...',
    'Fueling the engines...',
    'Calibrating the algorithms...',
    'Creating the experience...',
    'Generating inspiration...',
    'Igniting creativity...',
    'Building the dreams...',
    'Shaping the future...',
  ];

  String randomPhrase = '';
  Timer? timer;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    animation = Tween<double>(begin: 0, end: 360).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    randomPhrase = loadingPhrases[Random().nextInt(loadingPhrases.length)];

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        randomPhrase = loadingPhrases[Random().nextInt(loadingPhrases.length)];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: animation,
              builder: (_, child) {
                return Transform.rotate(
                  angle: animation.value * (3.1416 / 180),
                  child: child,
                );
              },
              child: Image.asset(
                'assets/logo-no-background-icon.png',
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              randomPhrase,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    timer?.cancel();
    super.dispose();
  }
}

class LoadingIndicatorFull extends StatefulWidget {
  const LoadingIndicatorFull({Key? key}) : super(key: key);

  @override
  LoadingIndicatorFullState createState() => LoadingIndicatorFullState();
}

class LoadingIndicatorFullState extends State<LoadingIndicatorFull>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).colorScheme.primary,
        color: Theme.of(context).colorScheme.secondary,
        strokeWidth: 3,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  LoadingIndicatorState createState() => LoadingIndicatorState();
}

class LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: Theme.of(context).colorScheme.secondary,
      strokeWidth: 3,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:nexis/classes/route_names.dart';
import 'package:nexis/pages/auth/utility/route_change.dart';
import '../../widgets/custom_button.dart';
import 'dart:async';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  EmailVerificationState createState() => EmailVerificationState();
}

class EmailVerificationState extends State<EmailVerificationPage> {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final firebase_auth.FirebaseAuth firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

  ValueNotifier<bool> isEmailVerified = ValueNotifier(false);
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified.value = firebaseAuth.currentUser!.emailVerified;

    isEmailVerified.addListener(RouteChange(context, RouteNames.authPage).reDir);

    if (!isEmailVerified.value) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = firebaseAuth.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  Future<void> checkEmailVerified() async {
    await firebaseAuth.currentUser!.reload();

    setState(() {
      isEmailVerified.value = firebaseAuth.currentUser!.emailVerified;
    });

    if (isEmailVerified.value) {
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              './assets/logo-no-background-icon.png',
              fit: BoxFit.contain,
              height: 50,
            ),
            Container(
                padding: const EdgeInsets.all(8.0), child: const Text('NEXIS')),
          ],
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 350,
            ),
            child: ListView(children: <Widget>[
              Card(
                margin: const EdgeInsets.all(20),
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.secondary,
                            strokeWidth: 4.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          'Waiting for Email Verification',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: CustomButton(
                          icon: const Icon(Icons.email, size: 32),
                          onPressed:
                              canResendEmail ? sendVerificationEmail : null,
                          text: "Resend Email",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

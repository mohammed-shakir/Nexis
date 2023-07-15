import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:nexis/classes/route_names.dart';
import 'package:nexis/pages/auth/auth_page.dart';
import 'package:nexis/pages/auth/utility/route_change.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_screen.dart';
import 'dart:async';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({
    Key? key,
  }) : super(key: key);

  @override
  EmailVerificationState createState() => EmailVerificationState();
}

class EmailVerificationState extends State<EmailVerificationPage> {
  static final firebase_auth.FirebaseAuth firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

  ValueNotifier<bool> isEmailVerified = ValueNotifier(false);
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified.value = firebaseAuth.currentUser!.emailVerified;
    updateUserData();

    if (!isEmailVerified.value) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  Future<void> updateUserData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      var doc = await firestore
          .collection('users')
          .where('email', isEqualTo: firebaseAuth.currentUser?.email)
          .get();
      if (doc.docs.isNotEmpty) {
        var userDocId = doc.docs.first.id;
        await firestore
            .collection('users')
            .doc(userDocId)
            .update({'isVerified': isEmailVerified.value});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
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
    try {
      await firebaseAuth.currentUser!.reload();

      setState(() {
        isEmailVerified.value = firebaseAuth.currentUser!.emailVerified;
      });

      if (isEmailVerified.value) {
        timer?.cancel();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified.value
      ? FutureBuilder<void>(
          future: updateUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              firebaseAuth.signOut();
              return const AuthPage();
            } else {
              return const LoadingScreen();
            }
          },
        )
      : Scaffold(
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
                    padding: const EdgeInsets.all(8.0),
                    child: const Text('NEXIS')),
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
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(
                              child: LoadingIndicator(),
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
                          const SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                                text: "Back",
                                style: Theme.of(context).textTheme.bodyMedium,
                                recognizer: TapGestureRecognizer()
                                  ..onTap =
                                      RouteChange(context, RouteNames.authPage)
                                          .reDir),
                          )
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

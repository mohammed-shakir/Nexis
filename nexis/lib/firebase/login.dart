import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class Login {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final firebase_auth.FirebaseAuth firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

  static Future<void> signIn(String email, String password) async {
    try {
      if (kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
        print('login.dart signIn');
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
      } else if (Platform.isWindows || Platform.isLinux) {
        await auth.signIn(email, password);
      }
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }
}

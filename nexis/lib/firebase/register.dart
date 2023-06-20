import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class Register {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final firebase_auth.FirebaseAuth firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

  static Future<void> signUp(String email, String password) async {
    try {
      if (kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
        await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
      } else if (Platform.isWindows || Platform.isLinux) {
        await auth.signUp(email, password);
      }
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }
}
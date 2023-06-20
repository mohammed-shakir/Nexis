import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firedart/firedart.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' show Platform;

class Register {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final firebase_auth.FirebaseAuth firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

  static Future<void> signUp(String email, String username, String password,
      String dateOfBirth) async {
    try {
      if (kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
        await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        await createUserDocument(email, username, password, dateOfBirth);
      } else if (Platform.isWindows || Platform.isLinux) {
        await auth.signUp(email, password);
      }
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  static createUserDocument(String email, String username,
    String password, String dateOfBirth) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore.collection('users').add({
      'avatar': '',
      'bio': '',
      'createdAt': DateTime.now(),
      'dateOfBirth': dateOfBirth,
      'displayName': username,
      'email': email,
      'friends': [],
      'servers': [],
      'userName': username,
    })
    .onError((error, stackTrace) async => await deleteUser());
  }

  static deleteUser() async {
    //delete user
  }
}

import 'package:flutter/material.dart';
import 'package:nexis/pages/main/home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../pages/auth/auth_page.dart';

class UserProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  bool _isVerified = false;
  bool get isVerified => _isVerified;
  late SharedPreferences prefs;
  static final firebase_auth.FirebaseAuth firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

  UserProvider() {
    init();
  }

  Future<void> updateUserData(String email) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      var user = firebaseAuth.currentUser;
      var doc = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (doc.docs.isNotEmpty) {
        var userDocId = doc.docs.first.id;
        await firestore
            .collection('users')
            .doc(userDocId)
            .update({'isVerified': user?.emailVerified ?? false});
      }
    } catch (e) {
      throw Exception('Failed to verify email: $e');
    }
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _isVerified = prefs.getBool('isVerified') ?? false;
    notifyListeners();
  }

  Future<void> login() async {
    var user = firebaseAuth.currentUser;
    _isVerified = user!.emailVerified;
    await prefs.setBool('isVerified', _isVerified);
    _isLoggedIn = true;
    await prefs.setBool('isLoggedIn', true);
    notifyListeners();
  }

  Future<void> logout() async {
    _isVerified = false;
    await prefs.setBool('isVerified', false);
    _isLoggedIn = false;
    await prefs.setBool('isLoggedIn', false);
    notifyListeners();
  }

  Future<void> fetchUserData(String email) async {
    updateUserData(email);

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var doc = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    List<String> userData = [
      'avatar',
      'bio',
      'createdAt',
      'dateOfBirth',
      'displayName',
      'email',
      'friends',
      'servers',
      'userName',
      'isVerified',
    ];
    if (doc.docs.isNotEmpty) {
      var userDoc = doc.docs.first;

      for (var i = 0; i < userData.length; i++) {
        var data = userData[i];
        var value = userDoc[data];

        if (value is Timestamp) {
          prefs.setString(data, value.toDate().toString());
        } else if (value is bool) {
          prefs.setBool(data, value);
        } else if (value is List<dynamic>) {
          prefs.setStringList(
              data, value.map((item) => item.toString()).toList());
        } else {
          prefs.setString(data, value);
        }
      }

      notifyListeners();
    }
  }
}

class ProtectedRoute extends StatelessWidget {
  final Widget child;
  const ProtectedRoute({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.isLoggedIn && userProvider.isVerified) {
          return this.child;
        } else {
          return const AuthPage();
        }
      },
    );
  }
}

class AuthRoute extends StatelessWidget {
  final Widget child;
  const AuthRoute({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (!userProvider.isLoggedIn || !userProvider.isVerified) {
          return this.child;
        } else {
          return const Home();
        }
      }
    );
  }
}

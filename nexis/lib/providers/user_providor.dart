import 'package:flutter/material.dart';
import '../pages/auth/auth_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  late SharedPreferences prefs;

  UserProvider() {
    init();
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  Future<void> login() async {
    _isLoggedIn = true;
    await prefs.setBool('isLoggedIn', true);
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    await prefs.setBool('isLoggedIn', false);
    notifyListeners();
  }

  Future<void> fetchUserData(String email) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var doc = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    List<String> userData = [
      'avatar',
      'bio',
      'color',
      'createdAt',
      'displayName',
      'email',
      'friends',
      'servers',
      'userName'
    ];
    if (doc.docs.isNotEmpty) {
      var userDoc = doc.docs.first;

      for (var i = 0; i < userData.length; i++) {
        var data = userData[i];
        var value = userDoc[data];

        if (value is Timestamp) {
          prefs.setString(data, value.toDate().toString());
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
        if (userProvider.isLoggedIn) {
          return this.child;
        } else {
          return const AuthPage();
        }
      },
    );
  }
}

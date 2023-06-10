import 'package:flutter/material.dart';
import 'auth_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

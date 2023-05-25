import 'package:flutter/material.dart';
import 'auth_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  late final Future<void> initialization;
  bool _isLoggedIn = false;
  late SharedPreferences _prefs;

  bool get isLoggedIn => _isLoggedIn;

  UserProvider() {
    initialization = _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _isLoggedIn = _prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  Future<void> login() async {
    _isLoggedIn = true;
    await _prefs.setBool('isLoggedIn', _isLoggedIn);
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    await _prefs.setBool('isLoggedIn', _isLoggedIn);
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

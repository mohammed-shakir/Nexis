import 'package:flutter/material.dart';
import 'auth_page.dart';
import 'package:provider/provider.dart';

class UserProvider with ChangeNotifier {
  late final Future<void> initialization;
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  UserProvider() {
    initialization = _init();
  }

  Future<void> _init() async {
    print('UserProvider init');
    notifyListeners();
  }

  Future<void> login() async {
    print('UserProvider login');
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    print('UserProvider logout');
    _isLoggedIn = false;
    notifyListeners();
  }
}

class ProtectedRoute extends StatelessWidget {
  final Widget child;
  const ProtectedRoute({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    print("balls");
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.isLoggedIn) {
          print('UserProvider ProtectedRoute: isLoggedIn');
          return this.child;
        } else {
          print('UserProvider ProtectedRoute: not isLoggedIn');
          return const AuthPage();
        }
      },
    );
  }
}

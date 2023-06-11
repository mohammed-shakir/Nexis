import 'package:flutter/material.dart';
import 'firebase/firebase_init.dart';
import 'classes/route_names.dart';
import 'pages/main/home.dart';
import 'pages/settings/settings_page.dart';
import 'pages/auth/auth_page.dart';
import 'themes/default_theme.dart';
import 'providers/user_providor.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeFirebase();

  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: const Nexis(),
    ),
  );
}

class Nexis extends StatelessWidget {
  const Nexis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexis',
      theme: appTheme,
      initialRoute: RouteNames.authPage,
      debugShowCheckedModeBanner: false, // remove debug banner
      routes: {
        RouteNames.authPage: (context) => const AuthPage(),
        RouteNames.home: (context) => const ProtectedRoute(child: Home()),
        RouteNames.settingsPage: (context) =>
            const ProtectedRoute(child: SettingsPage()),
      },
    );
  }
}

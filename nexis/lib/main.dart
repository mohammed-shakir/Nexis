import 'package:flutter/material.dart';
import 'firebase/firebase_init.dart';
import 'classes/route_names.dart';
import 'pages/home.dart';
import 'pages/settings/settings_page.dart';
import 'themes/default_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeFirebase();

  const app = Nexis();

  runApp(app);
}

class Nexis extends StatelessWidget {
  const Nexis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexis',
      theme: appTheme,
      initialRoute: RouteNames.home,
      // remove debug banner
      debugShowCheckedModeBanner: false,
      routes: {
        RouteNames.home: (context) => const Home(),
        RouteNames.settingsPage: (context) => const SettingsPage(),
      },
    );
  }
}

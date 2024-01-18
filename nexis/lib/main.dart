import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nexis/pages/auth/register_page.dart';
import 'package:nexis/services/connectivity_service.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'firebase/firebase_init.dart';
import 'classes/route_names.dart';
import 'pages/main/home.dart';
import 'pages/settings/settings_page.dart';
import 'pages/auth/auth_page.dart';
import 'pages/offline/offline_page.dart';
import 'themes/default_theme.dart';
import 'providers/user_providor.dart';
import 'providers/server_providor.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeFirebase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ServerProvider()),
      ],
      child: const Nexis(),
    ),
  );
}

class Nexis extends StatelessWidget {
  const Nexis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final connectivityService = ConnectivityService();

    return MaterialApp(
      title: 'Nexis',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      routes: {
        RouteNames.authPage: (context) => const AuthRoute(child: AuthPage()),
        RouteNames.registerPage: (context) =>
            const AuthRoute(child: RegisterPage()),
        RouteNames.home: (context) => const ProtectedRoute(child: Home()),
        RouteNames.settingsPage: (context) =>
            const ProtectedRoute(child: SettingsPage()),
        RouteNames.offlinePage: (context) =>
            const AuthRoute(child: OfflinePage()),
      },
      home: StreamBuilder<ConnectivityResult>(
        stream: connectivityService.onConnectivityChanged,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == ConnectivityResult.none) {
            // No internet connection
            return const OfflinePage();
          } else {
            // Internet Connection Available
            return Navigator(
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case RouteNames.home:
                    return MaterialPageRoute(
                        builder: (context) =>
                            const ProtectedRoute(child: Home()));
                  case RouteNames.settingsPage:
                    return MaterialPageRoute(
                        builder: (context) =>
                            const ProtectedRoute(child: SettingsPage()));
                  case RouteNames.authPage:
                    return MaterialPageRoute(
                        builder: (context) =>
                            const AuthRoute(child: AuthPage()));
                  case RouteNames.registerPage:
                    return MaterialPageRoute(
                        builder: (context) =>
                            const AuthRoute(child: RegisterPage()));
                  default:
                    return MaterialPageRoute(
                        builder: (context) => const AuthPage());
                }
              },
              initialRoute: RouteNames.home,
            );
          }
        },
      ),
    );
  }
}

// class Nexis extends StatelessWidget {
//   const Nexis({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final connectivityService = ConnectivityService();

//     return StreamBuilder<ConnectivityResult>(
//       stream: connectivityService.onConnectivityChanged,
//       builder: (context, snapshot) {
//         if (snapshot.hasData && snapshot.data == ConnectivityResult.none) {
//           // No internet connection
//           print('No internet connection');
//           return const MaterialApp(
//             home: OfflinePage(),
//           );
//         } else {
//           print('Connection');
//           return MaterialApp(
//             title: 'Nexis',
//             theme: appTheme,
//             initialRoute: RouteNames.home,
//             debugShowCheckedModeBanner: false, // remove debug banner
//             routes: {
//               RouteNames.authPage: (context) => const AuthRoute(child: AuthPage()),
//               RouteNames.registerPage: (context) => const AuthRoute(child: RegisterPage()),
//               RouteNames.home: (context) => const ProtectedRoute(child: Home()),
//               RouteNames.settingsPage: (context) => const ProtectedRoute(child: SettingsPage()),
//             },
//           );
//         }
//       },
//     );
//   }
// }


// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await initializeFirebase();

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => UserProvider()),
//         ChangeNotifierProvider(create: (context) => ServerProvider()),
//       ],
//       child: const Nexis(),
//     ),
//   );
// }

// class Nexis extends StatelessWidget {
//   const Nexis({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Nexis',
//       theme: appTheme,
//       initialRoute: RouteNames.home,
//       debugShowCheckedModeBanner: false, // remove debug banner
//       routes: {
//         RouteNames.authPage: (context) => const AuthRoute(child: AuthPage()),
//         RouteNames.registerPage: (context) =>
//             const AuthRoute(child: RegisterPage()),
//         RouteNames.home: (context) => const ProtectedRoute(child: Home()),
//         RouteNames.settingsPage: (context) =>
//             const ProtectedRoute(child: SettingsPage()),
//       },
//     );
//   }
// }

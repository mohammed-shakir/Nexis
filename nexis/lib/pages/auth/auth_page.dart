import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nexis/widgets/auth/column_type.dart';
import 'package:nexis/widgets/auth/custom_column.dart';
import 'package:provider/provider.dart';
import '../../classes/route_change.dart';
import '../../firebase/login.dart';
import '../../classes/route_names.dart';
import '../../pages/auth/user_providor.dart';
import '../../enums/screen_type.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signIn() async {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await Login.signIn(email, password);

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.initialization;
        await userProvider.login();

        emailController.clear();
        passwordController.clear();

        if (userProvider.isLoggedIn) {
          Navigator.pushReplacementNamed(context, RouteNames.home);
        }
      } catch (e) {
        passwordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wrong email or password: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var screenType = getScreenType(mediaQuery);

    switch (screenType) {
      case ScreenType.mobile:
        return AuthPage(context);
      case ScreenType.tablet:
        return AuthPage(context);
      case ScreenType.desktop:
        return AuthPage(context);
      default:
        return AuthPage(context);
    }
  }

  Widget AuthPage(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 550,
            ),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    "./assets/logo-no-background-icon.png",
                    fit: BoxFit.contain,
                    height: 200,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'NEXIS',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(20),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomColumn(
                          ColumnType.type1,
                          largeLabel: 'Welcome!',
                          mediumLabel: 'Email',
                          controller: emailController,
                          onSubmitted: (_) {
                            signIn();
                          },
                        ),
                        const SizedBox(height: 30),
                        CustomColumn(
                          ColumnType.type2,
                          mediumLabel: 'Password',
                          obscureText: true,
                          controller: passwordController,
                          onSubmitted: (_) {
                            signIn();
                          },
                          mediumBody: 'Forgot your password?',
                          recognizer: TapGestureRecognizer()..onTap = RouteChange(context, '').reDir,
                        ),
                        const SizedBox(height: 30),
                        CustomColumn(
                          ColumnType.type4,
                          onPressed: signIn,
                          buttonText: 'Sign In',
                          smallLabel: 'Need an account? ',
                          mediumBody: 'Register',
                          recognizer: TapGestureRecognizer()..onTap = RouteChange(context, RouteNames.registerPage).reDir,
                        ),
                      ],
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}

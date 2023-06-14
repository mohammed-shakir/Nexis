import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nexis/widgets/custom_button.dart';
import 'package:nexis/widgets/auth/custom_input_field.dart';
import 'package:provider/provider.dart';
import '../../classes/route_change.dart';
import '../../firebase/login.dart';
import '../../classes/route_names.dart';
import '../../pages/auth/user_providor.dart';

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
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome!', 
                              style: Theme.of(context).textTheme.labelLarge,
                              ),
                            const SizedBox(height: 10),
                            Text(
                              'Email', 
                              style: Theme.of(context).textTheme.labelMedium,
                              ),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: 500,
                              child: CustomTextField(
                                controller: emailController,
                                onSubmitted: (_) {
                                  signIn();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Password', 
                              style: Theme.of(context).textTheme.labelMedium,
                              ),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: 500,
                              child: CustomTextField(
                                obscureText: true,
                                controller: passwordController,
                                onSubmitted: (_) {
                                  signIn();
                                },
                              ),
                            ),
                            const SizedBox(height: 5),
                            RichText(
                              text: TextSpan(
                              text: 'Forgot your password?', 
                              style: Theme.of(context).textTheme.bodyMedium,
                              recognizer: TapGestureRecognizer()..onTap = RouteChange(context, '').reDir,
                              mouseCursor: SystemMouseCursors.click,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 500,
                              height: 50,
                              child: CustomButton(
                                onPressed: signIn,
                                text: 'Sign In',
                              ),
                            ), 
                            const SizedBox(height: 5),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Need an account? ', 
                                    style: Theme.of(context).textTheme.labelSmall,
                                  ),
                                  TextSpan(
                                    text: 'Register',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    recognizer: TapGestureRecognizer()..onTap = RouteChange(context, RouteNames.registerPage).reDir,
                                    mouseCursor: SystemMouseCursors.click,
                                  ),
                                ],
                              ),
                            ),
                          ],
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

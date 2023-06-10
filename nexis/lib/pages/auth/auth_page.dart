import 'package:flutter/material.dart';
import 'package:nexis/widgets/custom_button.dart';
import '../../firebase/login.dart';
import '../../classes/route_names.dart';
import 'user_providor.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  bool rememberMe = false;
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
        await userProvider.login();

        emailController.clear();
        passwordController.clear();

        if (userProvider.isLoggedIn) {
          Navigator.pushNamed(context, RouteNames.home);
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
              maxWidth: 800,
            ),
            child: Card(
              margin: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      onSubmitted: (_) {
                        signIn();
                      },
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      onSubmitted: (_) {
                        signIn();
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value ?? false;
                            });
                          },
                        ),
                        const Text('Remember Me'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      onPressed: signIn,
                      text: 'Sign In',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nexis/pages/auth/utility/column_type.dart';
import 'package:nexis/widgets/auth/custom_column.dart';
import 'package:nexis/widgets/input/basic_input_field.dart';
import 'package:nexis/widgets/input/password_input_field.dart';
import 'package:provider/provider.dart';
import 'utility/route_change.dart';
import '../../firebase/login.dart';
import '../../classes/route_names.dart';
import '../../providers/user_providor.dart';
import '../../widgets/loading_screen.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  final authKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  static final firebase_auth.FirebaseAuth firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signIn() async {
    final isValid = authKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoadingScreen(),
      ),
    );

    String email = emailController.text;
    String password = passwordController.text;
    var navigator = Navigator.of(context);

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        await Login.signIn(email, password);
        await userProvider.fetchUserData(email);
        await userProvider.init();
        await userProvider.login();

        emailController.clear();
        passwordController.clear();

        if (userProvider.isLoggedIn) {
          if (!userProvider.isVerified) {
            await userProvider.logout();
            setState(() {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Awaiting email verification for email: $email')),
              );
            });
          } else {
            navigator.pushNamed(RouteNames.home);
          }
        }
      } catch (e) {
        passwordController.clear();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wrong email or password: $e')),
        );
      }
    }
  }

  bool emptyFieldCheck() {
    return emailController.value.text.isNotEmpty &&
        passwordController.value.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return authPage(context);
  }

  Widget authPage(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 550,
            ),
            child: ListView(children: <Widget>[
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
                  child: authForm(context),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget authForm(BuildContext context) {
    return Form(
      key: authKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomColumn(
            type: ColumnType.type1,
            largeLabel: 'Welcome!',
            mediumLabel: 'Email',
            inputField: BasicInputField(
              controller: emailController,
              onFieldSubmitted: (_) {
                emptyFieldCheck() ? signIn() : null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (text) =>
                  text != null && !EmailValidator.validate(text)
                      ? 'Invalid email format'
                      : null,
            ),
          ),
          const SizedBox(height: 30),
          CustomColumn(
            type: ColumnType.type2,
            mediumLabel: 'Password',
            inputField: PasswordInputField(
              controller: passwordController,
              onFieldSubmitted: (_) {
                emptyFieldCheck() ? signIn() : null;
              },
            ),
            mediumBody: 'Forgot your password?',
            recognizer: TapGestureRecognizer()
              ..onTap = RouteChange(context, '').reDir,
          ),
          const SizedBox(height: 30),
          CustomColumn(
            type: ColumnType.type4,
            onPressed: () {
              emptyFieldCheck() ? signIn() : null;
            },
            buttonText: 'Sign In',
            smallLabel: 'Need an account? ',
            mediumBody: 'Register',
            recognizer: TapGestureRecognizer()
              ..onTap = RouteChange(context, RouteNames.registerPage).reDir,
          ),
        ],
      ),
    );
  }
}

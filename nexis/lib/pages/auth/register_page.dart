import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexis/widgets/custom_button.dart';
import 'package:nexis/widgets/auth/custom_input_field.dart';
import 'package:provider/provider.dart';
import '../../classes/route_change.dart';
import '../../firebase/login.dart';
import '../../classes/route_names.dart';
import '../../pages/auth/user_providor.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              './assets/logo-no-background-icon.png',
              fit: BoxFit.contain,
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.all(8.0), child: const Text('NEXIS')
            ),
          ],
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 550,
            ),
            child: ListView(
              children: <Widget>[
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
                            SizedBox(
                              width: 500,
                              height: 50,
                              child: CustomButton(
                                //onPressed: {Function},
                                text: 'Register',
                              ),
                            ), 
                            const SizedBox(height: 5),
                            RichText(
                              text: TextSpan(
                                text: 'Already have an account?',
                                style: Theme.of(context).textTheme.bodyMedium,
                                recognizer: TapGestureRecognizer()..onTap = RouteChange(context, RouteNames.authPage).reDir,
                                mouseCursor: SystemMouseCursors.click,
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
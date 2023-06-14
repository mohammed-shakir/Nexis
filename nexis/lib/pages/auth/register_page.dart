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
  final TextEditingController yearController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController dayController = TextEditingController();

  final List<String> months = ["January","February","March","April","May","June","July",
            "August","September","October","November","December"];

  selectDate() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 100, 1),
      initialDate: DateTime.now(),
      lastDate: DateTime.now(),
    );

    if (newDate == null) return;

    // Assign new date to date controllers
    setState(() {
      yearController.text = '${newDate.year}';
      monthController.text = months[(newDate.month)-1];
      dayController.text = '${newDate.day}';
    });
    //print(date);
  }

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
                            Text(
                              'Create an account', 
                              style: Theme.of(context).textTheme.labelLarge,
                              ),
                            const SizedBox(height: 10),
                            Text(
                              'Email', 
                              style: Theme.of(context).textTheme.labelMedium,
                              ),
                            const SizedBox(height: 5),
                            const SizedBox(
                              width: 500,
                              child: CustomTextField(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Username', 
                              style: Theme.of(context).textTheme.labelMedium,
                              ),
                            const SizedBox(height: 5),
                            const SizedBox(
                              width: 500,
                              child: CustomTextField(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Password', 
                              style: Theme.of(context).textTheme.labelMedium,
                              ),
                            const SizedBox(height: 5),
                            const SizedBox(
                              width: 500,
                              child: CustomTextField(
                                obscureText: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Repeat Password', 
                              style: Theme.of(context).textTheme.labelMedium,
                              ),
                            const SizedBox(height: 5),
                            const SizedBox(
                              width: 500,
                              child: CustomTextField(
                                obscureText: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date of birth', 
                              style: Theme.of(context).textTheme.labelMedium,
                              ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                SizedBox(
                                  width: 160,
                                  child: CustomTextField(
                                    obscureText: false,
                                    hint: 'Month',
                                    onTap: selectDate,
                                    controller: monthController,
                                    readOnly: true,
                                  ),
                                ),
                                const SizedBox(width: 25),
                                SizedBox(
                                  width: 120,
                                  child: CustomTextField(
                                    obscureText: false,
                                    hint: 'Day',
                                    onTap: selectDate,
                                    controller: dayController,
                                    readOnly: true,
                                  ),
                                ),
                                const SizedBox(width: 25),
                                SizedBox(
                                  width: 140,
                                  child: CustomTextField(
                                    obscureText: false,
                                    hint: 'Year',
                                    onTap: selectDate,
                                    controller: yearController,
                                    readOnly: true,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
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
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nexis/pages/auth/utility/column_type.dart';
import 'package:nexis/widgets/auth/custom_column.dart';
import 'utility/route_change.dart';
import '../../firebase/register.dart';
import '../../classes/route_names.dart';
import '../../enums/screen_type.dart';
import 'email_verification_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final regKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Desktop || Tablet
  final TextEditingController yearController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController dayController = TextEditingController();

  // Mobile
  final TextEditingController dateController = TextEditingController();

  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  bool obscureText = true;
  bool obscureTextRepeat = true;

  bool isRegistered = false;

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    yearController.dispose();
    monthController.dispose();
    dayController.dispose();
    dateController.dispose();

    super.dispose();
  }

  void clearFields() {
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void signUp() async {
    final isValid = regKey.currentState!.validate();
    if (!isValid) { 
      return; 
    }

    BuildContext dialogContext = context;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        dialogContext = context;
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.secondary,
            strokeWidth: 4.0,
          ));
      }
    );

    String email = emailController.text;
    String username = usernameController.text;
    String password = passwordController.text;
    String dateOfBirth = dateController.text;

    try {
      await Register.signUp(email, username, password, dateOfBirth);
      setState(() {
        Navigator.pop(dialogContext);
        isRegistered = true;
      });
    } catch (e) {
      clearFields();
      Navigator.pop(dialogContext);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

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
      dateController.text = '${months[(newDate.month)-1]}-${newDate.day}-${newDate.year}';
    });
  }

  bool passwordCheck(String? text) {
    bool hasUppercase = text!.contains(RegExp(r'[A-Z]'));
    bool hasDigits = text.contains(RegExp(r'[0-9]'));
    bool hasLowercase = text.contains(RegExp(r'[a-z]'));
    bool hasSpecialCharacters = text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = text.length >= 8;

    return hasUppercase && hasDigits && hasLowercase && hasSpecialCharacters && hasMinLength;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var screenType = getScreenType(mediaQuery);

    switch (screenType) {
      case ScreenType.mobile:
        return registerPageMobile(context);
      case ScreenType.tablet:
        return registerPageDesktop(context);
      case ScreenType.desktop:
        return registerPageDesktop(context);
      default:
        return registerPageDesktop(context);
    }
  }

  Widget registerPageMobile(BuildContext context) => isRegistered
    ? const EmailVerificationPage()
    : Scaffold(
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
            child: ListView(children: <Widget>[
              Card(
                margin: const EdgeInsets.all(20),
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form (
                    key: regKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [ 
                        CustomColumn(
                          type: ColumnType.type1,
                          largeLabel: 'Create an account',
                          mediumLabel: 'Email',
                          controller: emailController,
                          onSubmitted: (_) {
                            signUp();
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (text) =>
                            text != null && !EmailValidator.validate(text)
                              ? 'Invalid email format'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        CustomColumn(
                          type: ColumnType.type3,
                          mediumLabel: 'Username',
                          controller: usernameController,
                          onSubmitted: (_) {
                            signUp();
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomColumn(
                          type: ColumnType.type3,
                          mediumLabel: 'Password',
                          suffixIcon: IconButton(
                            icon: const Icon(true
                                ? Icons.visibility
                                // ignore: dead_code
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                          ),
                          obscureText: obscureText,
                          controller: passwordController,
                          onSubmitted: (_) {
                            signUp();
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (text) {
                            if (!passwordCheck(text)) {
                              return 'min 8 char. and (1) of [A-Z], [a-z], [0-9], [e.g., ! @ # ?]';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomColumn(
                          type: ColumnType.type3,
                          mediumLabel: 'Confirm Password',
                          suffixIcon: IconButton(
                            icon: const Icon(true
                                ? Icons.visibility
                                // ignore: dead_code
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                obscureTextRepeat = !obscureTextRepeat;
                              });
                            },
                          ),
                          obscureText: obscureTextRepeat,
                          controller: confirmPasswordController,
                          onSubmitted: (_) {
                            signUp();
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (text) {
                            if (text != passwordController.text) {
                              return '!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomColumn(
                          type: ColumnType.type3,
                          mediumLabel: 'Date of birth',
                          hint: 'Month-Day-Year',
                          controller: dateController,
                          onSubmitted: (_) {
                            signUp();
                          },
                          onTap: selectDate,
                          readOnly: true,
                        ),
                        const SizedBox(height: 20),
                        CustomColumn(
                          type: ColumnType.type4,
                          buttonText: 'Register',
                          onPressed: emailController.value.text.isNotEmpty && 
                                      usernameController.value.text.isNotEmpty &&
                                      passwordController.value.text.isNotEmpty &&
                                      confirmPasswordController.value.text.isNotEmpty &&
                                      dateController.value.text.isNotEmpty
                            ? signUp
                            : null,
                          mediumBody: 'Already have an account?',
                          recognizer: TapGestureRecognizer()
                            ..onTap = 
                              RouteChange(context, RouteNames.authPage).reDir,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  
  Widget registerPageDesktop(BuildContext context) => isRegistered
    ? const EmailVerificationPage()
    : Scaffold(
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
            child: ListView(children: <Widget>[
              Card(
                margin: const EdgeInsets.all(20),
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form (
                    key: regKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [ 
                        CustomColumn(
                          type: ColumnType.type1,
                          largeLabel: 'Create an account',
                          mediumLabel: 'Email',
                          controller: emailController,
                          onSubmitted: (_) {
                            signUp();
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (text) =>
                            text != null && !EmailValidator.validate(text)
                              ? 'Invalid email format'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        CustomColumn(
                          type: ColumnType.type3,
                          mediumLabel: 'Username',
                          controller: usernameController,
                          onSubmitted: (_) {
                            signUp();
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomColumn(
                          type: ColumnType.type3,
                          mediumLabel: 'Password',
                          suffixIcon: IconButton(
                            icon: const Icon(true
                                ? Icons.visibility
                                // ignore: dead_code
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                          ),
                          obscureText: obscureText,
                          controller: passwordController,
                          onSubmitted: (_) {
                            signUp();
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (text) {
                            if (!passwordCheck(text)) {
                              return 'Password needs to contain a minimum of 8 characters and at least one (1) of each:\nUppercase [A-Z], lowercase [a-z], number [0-9], special char. [e.g., ! @ # ?]';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomColumn(
                          type: ColumnType.type3,
                          mediumLabel: 'Confirm Password',
                          suffixIcon: IconButton(
                            icon: const Icon(true
                                ? Icons.visibility
                                // ignore: dead_code
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                obscureTextRepeat = !obscureTextRepeat;
                              });
                            },
                          ),
                          obscureText: obscureTextRepeat,
                          controller: confirmPasswordController,
                          onSubmitted: (_) {
                            signUp();
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (text) {
                            if (text != passwordController.text) {
                              return '!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomColumn(
                          type: ColumnType.type5,
                          mediumLabel: 'Date of birth',
                          monthController: monthController,
                          dayController: dayController,
                          yearController: yearController,
                          onSubmitted: (_) {
                            signUp();
                          },
                          onTap: selectDate,
                        ),
                        const SizedBox(height: 20),
                        CustomColumn(
                          type: ColumnType.type4,
                          buttonText: 'Register',
                          onPressed: emailController.value.text.isNotEmpty && 
                                      usernameController.value.text.isNotEmpty &&
                                      passwordController.value.text.isNotEmpty &&
                                      confirmPasswordController.value.text.isNotEmpty &&
                                      dateController.value.text.isNotEmpty
                            ? signUp
                            : null,
                          mediumBody: 'Already have an account?',
                          recognizer: TapGestureRecognizer()
                            ..onTap = 
                              RouteChange(context, RouteNames.authPage).reDir,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
}
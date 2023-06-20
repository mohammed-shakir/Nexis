import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nexis/pages/auth/utility/column_type.dart';
import 'package:nexis/widgets/auth/custom_column.dart';
import 'utility/route_change.dart';
import '../../firebase/register.dart';
import '../../classes/route_names.dart';
import '../../enums/screen_type.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
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

  void checkFields(String email, String username, String password,
    String confirmPassword, String dateOfBirth) {

    if (email.isEmpty || password.isEmpty || username.isEmpty ||
    confirmPassword.isEmpty || dateOfBirth.isEmpty) {
      clearFields();
      throw ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields must be filled')),
      );
    }

    if (password != confirmPassword) {
      clearFields();
      throw ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Confirm password')),
      );
    }
  }

  void signUp() async {
    String email = emailController.text;
    String username = usernameController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    String dateOfBirth = dateController.text;

    var navigator = Navigator.of(context);

    checkFields(email, username, password, confirmPassword, dateOfBirth);

    try {
      await Register.signUp(email, username, password, dateOfBirth);
      navigator.pushNamed(RouteNames.authPage);
    } catch (e) {
      clearFields();
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

  Widget registerPageMobile(BuildContext context) {
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
                        CustomColumn(
                          type: ColumnType.type1,
                          largeLabel: 'Create an account',
                          mediumLabel: 'Email',
                          controller: emailController,
                          onSubmitted: (_) {
                            signUp();
                          },
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
                          onPressed: signUp,
                          mediumBody: 'Already have an account?',
                          recognizer: TapGestureRecognizer()..onTap = RouteChange(context, RouteNames.authPage).reDir,
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
  
  Widget registerPageDesktop(BuildContext context) {
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
                        CustomColumn(
                          type: ColumnType.type1,
                          largeLabel: 'Create an account',
                          mediumLabel: 'Email',
                          controller: emailController,
                          onSubmitted: (_) {
                            signUp();
                          },
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
                          onPressed: signUp,
                          mediumBody: 'Already have an account?',
                          recognizer: TapGestureRecognizer()..onTap = RouteChange(context, RouteNames.authPage).reDir,
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
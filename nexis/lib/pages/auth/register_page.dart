import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nexis/pages/auth/utility/column_type.dart';
import 'package:nexis/widgets/auth/custom_column.dart';
import 'utility/route_change.dart';
import '../../classes/route_names.dart';
import '../../enums/screen_type.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  // Desktop || Tablet
  final TextEditingController yearController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController dayController = TextEditingController();

  // Mobile
  final TextEditingController dateController = TextEditingController();
  
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
                        const CustomColumn(
                          type: ColumnType.type1,
                          largeLabel: 'Create an account',
                          mediumLabel: 'Email',
                          /*
                            Add here for further implementation
                          */ 
                        ),
                        const SizedBox(height: 20),
                        const CustomColumn(
                          type: ColumnType.type3,
                          mediumLabel: 'Username',
                          /*
                            Add here for further implementation
                          */ 
                        ),
                        const SizedBox(height: 20),
                        const CustomColumn(
                          type: ColumnType.type3,
                          mediumLabel: 'Password',
                          obscureText: true,
                          /*
                            Add here for further implementation
                          */ 
                        ),
                        const SizedBox(height: 20),
                        const CustomColumn(
                          type: ColumnType.type3,
                          mediumLabel: 'Repeat Password',
                          obscureText: true,
                          /*
                            Add here for further implementation
                          */ 
                        ),
                        const SizedBox(height: 20),
                        CustomColumn(
                          type: ColumnType.type3,
                          mediumLabel: 'Date of birth',
                          hint: 'Month-Day-Year',
                          controller: dateController,
                          onTap: selectDate,
                          readOnly: true,
                        ),
                        const SizedBox(height: 20),
                        CustomColumn(
                          type: ColumnType.type4,
                          buttonText: 'Register',
                          //onPressed: {Function},
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
                        const CustomColumn(
                          type: ColumnType.type1,
                          largeLabel: 'Create an account',
                          mediumLabel: 'Email',
                          /*
                            Add here for further implementation
                          */ 
                        ),
                        const SizedBox(height: 20),
                        const CustomColumn(
                          type: ColumnType.type3,
                          mediumLabel: 'Username',
                          /*
                            Add here for further implementation
                          */ 
                        ),
                        const SizedBox(height: 20),
                        const CustomColumn(
                          type: ColumnType.type3,
                          mediumLabel: 'Password',
                          obscureText: true,
                          /*
                            Add here for further implementation
                          */ 
                        ),
                        const SizedBox(height: 20),
                        const CustomColumn(
                          type: ColumnType.type3,
                          mediumLabel: 'Repeat Password',
                          obscureText: true,
                          /*
                            Add here for further implementation
                          */ 
                        ),
                        const SizedBox(height: 20),
                        CustomColumn(
                          type: ColumnType.type5,
                          mediumLabel: 'Date of birth',
                          monthController: monthController,
                          dayController: dayController,
                          yearController: yearController,
                          onTap: selectDate,
                        ),
                        const SizedBox(height: 20),
                        CustomColumn(
                          type: ColumnType.type4,
                          buttonText: 'Register',
                          //onPressed: {Function},
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
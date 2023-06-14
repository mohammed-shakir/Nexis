import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Servers extends StatefulWidget {
  const Servers({Key? key}) : super(key: key);

  @override
  ServersState createState() => ServersState();
}

class ServersState extends State<Servers> {
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onBackground,
    );
  }
}

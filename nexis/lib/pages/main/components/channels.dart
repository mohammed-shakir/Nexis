import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Channels extends StatefulWidget {
  const Channels({Key? key}) : super(key: key);

  @override
  ChannelsState createState() => ChannelsState();
}

class ChannelsState extends State<Channels> {
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
      color: Theme.of(context).colorScheme.background,
    );
  }
}

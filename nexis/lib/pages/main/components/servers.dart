import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/server_button.dart';

class Servers extends StatefulWidget {
  const Servers({Key? key}) : super(key: key);

  @override
  ServersState createState() => ServersState();
}

class ServersState extends State<Servers> {
  late SharedPreferences prefs;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onBackground,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ServerButton(
                    onPressed: () => setState(() => selectedIndex = 0),
                    image: const AssetImage(
                        "./assets/logo-no-background-icon.png"),
                    isSelected: selectedIndex == 0,
                    name: "Nexis",
                  ),
                  const SizedBox(height: 10),
                  ServerButton(
                    onPressed: () => setState(() => selectedIndex = 1),
                    image: const AssetImage("./assets/temp.png"),
                    isSelected: selectedIndex == 1,
                    name: "Test",
                  ),
                  const SizedBox(height: 10),
                  ServerButton(
                    onPressed: () => setState(() => selectedIndex = 2),
                    icon: const Icon(Icons.add),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    isSelected: selectedIndex == 2,
                    name: "Add A Server",
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

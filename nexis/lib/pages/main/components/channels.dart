import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/channel_button.dart';

class Channels extends StatefulWidget {
  const Channels({Key? key}) : super(key: key);

  @override
  ChannelsState createState() => ChannelsState();
}

class ChannelsState extends State<Channels> {
  late SharedPreferences prefs;
  int selectedIndex = 0;

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
    return buildServerChannels();
  }

  Widget buildDMs() {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          ChannelButton(
            onPressed: () => setState(() => selectedIndex = 0),
            icon: const Icon(Icons.home_filled),
            isSelected: selectedIndex == 0,
            name: "Nexis",
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'Direct Messages',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ChannelButton(
            onPressed: () => setState(() => selectedIndex = 1),
            image: const AssetImage("./assets/temp.png"),
            isSelected: selectedIndex == 1,
            name: "User",
          ),
          const SizedBox(height: 5),
          ChannelButton(
            onPressed: () => setState(() => selectedIndex = 2),
            image: const AssetImage("./assets/logo-no-background-icon.png"),
            isSelected: selectedIndex == 2,
            name: "Balls",
          ),
        ],
      ),
    );
  }

  Widget buildServerChannels() {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'Nexis',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'Text Channels',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ChannelButton(
            onPressed: () => setState(() => selectedIndex = 0),
            icon: const Icon(Icons.chat, size: 18),
            isSelected: selectedIndex == 0,
            size: 18,
            name: "General",
          ),
          const SizedBox(height: 5),
          ChannelButton(
            onPressed: () => setState(() => selectedIndex = 1),
            icon: const Icon(Icons.chat, size: 18),
            isSelected: selectedIndex == 1,
            size: 18,
            name: "Balls",
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'Voice Channels',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ChannelButton(
            onPressed: () => setState(() => selectedIndex = 2),
            icon: const Icon(Icons.volume_up_rounded, size: 18),
            isSelected: selectedIndex == 2,
            size: 18,
            name: "General",
          ),
          const SizedBox(height: 5),
          ChannelButton(
            onPressed: () => setState(() => selectedIndex = 3),
            icon: const Icon(Icons.volume_up_rounded, size: 18),
            isSelected: selectedIndex == 3,
            size: 18,
            name: "Meetings",
          ),
        ],
      ),
    );
  }
}

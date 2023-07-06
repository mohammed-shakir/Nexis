import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/channel_button.dart';
import '../../../widgets/hover_icon_button.dart';
import '../../../classes/route_names.dart';
import '../../../providers/server_providor.dart';
import 'package:provider/provider.dart';

class Channels extends StatefulWidget {
  const Channels({Key? key}) : super(key: key);

  @override
  ChannelsState createState() => ChannelsState();
}

class ChannelsState extends State<Channels> {
  late SharedPreferences prefs;
  int selectedIndex = 0;
  late Future<SharedPreferences> prefsFuture;
  late Future<List<String>> channelsDataFuture;

  @override
  void initState() {
    super.initState();

    prefsFuture = SharedPreferences.getInstance();
    var serverProvider = Provider.of<ServerProvider>(context, listen: false);
    channelsDataFuture = initSharedPreferences(serverProvider);
  }

  Future<List<String>> initSharedPreferences(
      ServerProvider serverProvider) async {
    prefs = await prefsFuture;
    String? serverId = prefs.getString('selectedServer');
    if (serverId != null) {
      return await serverProvider.fetchServerChannels(serverId);
    } else {
      return [];
    }
  }

  Future<List<String>> getChannels(ServerProvider serverProvider) async {
    String serverId = serverProvider.selectedServerId.toString();
    if (serverId != 'null') {
      return await serverProvider.fetchServerChannels(serverId);
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: channelsDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<String> channels = snapshot.data ?? [];
          print(channels);
          return Column(
            children: [
              Expanded(child: buildServerChannels(channels)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage("./assets/temp.png"),
                      backgroundColor: Colors.transparent,
                      radius: 15,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Shackman',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    HoverIconButton(
                      icon: const Icon(Icons.mic),
                      onPressed: () {},
                      color: Colors.grey,
                      hoverColor: Colors.white,
                      size: 20,
                    ),
                    HoverIconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        Navigator.pushNamed(context, RouteNames.settingsPage);
                      },
                      color: Colors.grey,
                      hoverColor: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget buildServerChannels(List<String> channels) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
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
            for (int i = 0; i < channels.length; i++)
              ChannelButton(
                onPressed: () => setState(() => selectedIndex = i),
                icon: const Icon(Icons.chat, size: 18),
                isSelected: selectedIndex == i,
                size: 18,
                name: channels[i],
              ),
            // ChannelButton(
            //   onPressed: () => setState(() => selectedIndex = 0),
            //   icon: const Icon(Icons.chat, size: 18),
            //   isSelected: selectedIndex == 0,
            //   size: 18,
            //   name: "General",
            // ),
            // const SizedBox(height: 5),
            // ChannelButton(
            //   onPressed: () => setState(() => selectedIndex = 1),
            //   icon: const Icon(Icons.chat, size: 18),
            //   isSelected: selectedIndex == 1,
            //   size: 18,
            //   name: "Balls",
            // ),
            Text(
              '''
              ${Provider.of<ServerProvider>(context).getServerChannels}!
              ''',
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
      ),
    );
  }

  Widget buildDMs() {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
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
      ),
    );
  }
}

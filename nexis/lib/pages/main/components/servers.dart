import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../../providers/server_providor.dart';
import '../../../widgets/server_button.dart';

class Servers extends StatefulWidget {
  const Servers({Key? key}) : super(key: key);

  @override
  ServersState createState() => ServersState();
}

class ServersState extends State<Servers> {
  late SharedPreferences? prefs;
  int selectedIndex = 0;
  late Future<SharedPreferences> prefsFuture;
  late Future<List<Map<String, dynamic>>> serversDataFuture;

  @override
  void initState() {
    super.initState();

    prefsFuture = SharedPreferences.getInstance();
    var serverProvider = Provider.of<ServerProvider>(context, listen: false);
    serversDataFuture = initSharedPreferences(serverProvider);
  }

  Future<List<Map<String, dynamic>>> initSharedPreferences(
      ServerProvider serverProvider) async {
    prefs = await prefsFuture;
    List<String>? serverIds = prefs?.getStringList('servers');
    if (serverIds != null && serverIds.isNotEmpty) {
      return Future.wait(serverIds.map(serverProvider.fetchServerData));
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: serversDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<Map<String, dynamic>> serversData = snapshot.data ?? [];
          return buildServers(serversData);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget buildServers(List<Map<String, dynamic>> serversData) {
    return Container(
      color: Theme.of(context).colorScheme.onBackground,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ServerButton(
                    onPressed: () => setState(() => selectedIndex = 0),
                    image: const AssetImage(
                        "./assets/logo-no-background-icon.png"),
                    isSelected: selectedIndex == 0,
                    name: "Direct Messages",
                  ),
                  const SizedBox(height: 10),
                  for (int i = 0; i < serversData.length; i++)
                    Column(
                      children: [
                        ServerButton(
                          onPressed: () {
                            setState(() {
                              selectedIndex = i + 1;
                              prefs?.setString('selectedServer',
                                  serversData[i]['id'].toString());
                            });
                          },
                          image: (serversData[i]['photo'] != null &&
                                  serversData[i]['photo'] != '' &&
                                  (serversData[i]['photo'] as String)
                                      .isNotEmpty)
                              ? NetworkImage(serversData[i]['photo'] as String)
                                  as ImageProvider<Object>
                              : const AssetImage(
                                  "./assets/logo-no-background-icon.png"),
                          isSelected: selectedIndex == i + 1,
                          name: serversData[i]['name'] ?? "Server Name",
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ServerButton(
                    onPressed: () =>
                        setState(() => selectedIndex = serversData.length + 1),
                    icon: const Icon(Icons.add),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    isSelected: selectedIndex == serversData.length + 1,
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

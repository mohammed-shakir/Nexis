import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../../providers/server_providor.dart';
import '../../../widgets/server_button.dart';

class Servers extends StatefulWidget {
  final void Function() onPressed;
  late int selectedIndex;
  late int i;
  late List<Map<String, dynamic>> serversData;
  late ServerProvider serverProvider;
  Servers(
      {Key? key,
      required this.onPressed,
      required this.selectedIndex,
      required this.i,
      required this.serversData,
      required this.serverProvider})
      : super(key: key);

  @override
  ServersState createState() => ServersState();
}

class ServersState extends State<Servers> {
  late SharedPreferences? prefs;
  late Future<SharedPreferences> prefsFuture;
  late Future<List<Map<String, dynamic>>> serversDataFuture;

  @override
  void initState() {
    super.initState();

    prefsFuture = SharedPreferences.getInstance();
    widget.serverProvider = Provider.of<ServerProvider>(context, listen: false);
    serversDataFuture = initSharedPreferences(widget.serverProvider);
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
          widget.serversData = snapshot.data ?? [];
          return buildServers(widget.serversData);
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
                    onPressed: () => setState(() => widget.selectedIndex = 0),
                    image: const AssetImage(
                        "./assets/logo-no-background-icon.png"),
                    isSelected: widget.selectedIndex == 0,
                    name: "Direct Messages",
                  ),
                  const SizedBox(height: 10),
                  for (widget.i = 0; widget.i < serversData.length; widget.i++)
                    Column(
                      children: [
                        ServerButton(
                          /*
                          onPressed: () {
                            setState(() => selectedIndex = i + 1);
                            prefs?.setString('selectedServer',
                                serversData[i]['id'].toString());
                            serverProvider.setSelectServer(
                                serversData[i]['id'].toString());
                          },
                          */
                          onPressed: widget.onPressed,
                          image: (serversData[widget.i]['photo'] != null &&
                                  serversData[widget.i]['photo'] != '' &&
                                  (serversData[widget.i]['photo'] as String)
                                      .isNotEmpty)
                              ? NetworkImage(
                                      serversData[widget.i]['photo'] as String)
                                  as ImageProvider<Object>
                              : const AssetImage(
                                  "./assets/logo-no-background-icon.png"),
                          isSelected: widget.selectedIndex == widget.i + 1,
                          name: serversData[widget.i]['name'] ?? "Server Name",
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ServerButton(
                    onPressed: () => setState(
                        () => widget.selectedIndex = serversData.length + 1),
                    icon: const Icon(Icons.add),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    isSelected: widget.selectedIndex == serversData.length + 1,
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

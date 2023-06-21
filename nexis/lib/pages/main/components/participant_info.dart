import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../../providers/server_providor.dart';

class ParticipantInfo extends StatefulWidget {
  const ParticipantInfo({Key? key}) : super(key: key);

  @override
  ParticipantInfoState createState() => ParticipantInfoState();
}

class ParticipantInfoState extends State<ParticipantInfo> {
  late Future<SharedPreferences> _prefsFuture;
  late Future<Map<String, dynamic>?> _serverDataFuture;

  String? displayName;
  List<String>? memberIds;

  @override
  void initState() {
    super.initState();

    _prefsFuture = SharedPreferences.getInstance();
    var serverProvider = Provider.of<ServerProvider>(context, listen: false);
    initSharedPreferences(serverProvider);
  }

  Future<void> initSharedPreferences(ServerProvider serverProvider) async {
    final prefs = await _prefsFuture;

    setState(() {
      displayName = prefs.getString('displayName');
    });

    List<String>? serverIds = prefs.getStringList('servers');
    if (serverIds != null && serverIds.isNotEmpty) {
      _serverDataFuture = serverProvider.fetchServerData(serverIds.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: _prefsFuture,
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return FutureBuilder<Map<String, dynamic>?>(
            future: _serverDataFuture,
            builder: (context, serverDataSnapshot) {
              if (serverDataSnapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic>? serverData = serverDataSnapshot.data;
                memberIds = List<String>.from(serverData?['member_ids'] ??
                    []); // setting 'memberIds' from 'serverData'
                return buildParticipantInfo();
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget buildParticipantInfo() {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Members',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          if (memberIds != null)
            ...memberIds!
                .map(
                  (member) => Column(
                    children: [
                      Text(
                        member,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                )
                .toList(),
        ],
      ),
    );
  }
}

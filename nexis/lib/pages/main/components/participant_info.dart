import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParticipantInfo extends StatefulWidget {
  const ParticipantInfo({Key? key}) : super(key: key);

  @override
  ParticipantInfoState createState() => ParticipantInfoState();
}

class ParticipantInfoState extends State<ParticipantInfo> {
  late SharedPreferences prefs;
  String? displayName;
  List<String>? friends;

  @override
  void initState() {
    super.initState();

    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName = prefs.getString('displayName');
      friends = prefs.getStringList('friends');
    });
  }

  @override
  Widget build(BuildContext context) {
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
          if (displayName != null)
            Text(
              displayName!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          const SizedBox(height: 10),
          if (friends != null)
            ...friends!
                .map(
                  (friend) => Column(
                    children: [
                      Text(
                        friend,
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

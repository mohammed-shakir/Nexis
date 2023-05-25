import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/message_item.dart';
import '../../classes/route_names.dart';
import '../../firebase/firestore_write.dart';
import '../../firebase/firestore_read.dart';
import '../../models/message_model.dart';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final TextEditingController messageController = TextEditingController();
  StreamSubscription<QuerySnapshot>? subscription;
  late final FirestoreRead firestoreRead;
  List<Message> messages = [];
  bool messagesLoaded = false;
  final FocusNode messageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    listenToMessages().then((_) {
      setState(() {
        // Update the UI
      });
    });
  }

  // Clean up resources that are no longer needed (messageController). If it is not removed, it could cause a memory leak.
  @override
  void dispose() {
    subscription?.cancel();
    messageController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    String messageContent = messageController.text.trim();
    if (messageContent.isNotEmpty) {
      try {
        await FirestoreWrite.sendMessage(
          message: messageController.text,
          sender: dotenv.env['TEMP_TEST_EMAIL']!,
          groupChatId: 'aNAgqEvRvtFLDmjw7Ivz',
        );
        messageController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending message: $e')),
        );
      }
    }
  }

  Future<void> listenToMessages() async {
    FirestoreRead firestoreRead =
        FirestoreRead(groupId: 'aNAgqEvRvtFLDmjw7Ivz');
    try {
      List<DocumentSnapshot> documents = await firestoreRead.initialFetch();
      Set<String> processedIds = documents.map((doc) => doc.id).toSet();

      messages.clear();

      Timestamp? lastMessageTimestamp;
      if (documents.isNotEmpty) {
        for (var document in documents.reversed) {
          messages.add(Message.fromDocument(document));
        }

        var lastMessageData = documents.last.data();
        if (lastMessageData != null &&
            lastMessageData is Map<String, dynamic>) {
          lastMessageTimestamp = lastMessageData['timestamp'] as Timestamp?;
        }
      }

      subscription = firestoreRead
          .listenToNewMessages(lastMessageTimestamp)
          .listen((querySnapshot) {
        for (var docChange in querySnapshot.docChanges) {
          DocumentSnapshot document = docChange.doc;
          switch (docChange.type) {
            case DocumentChangeType.added:
              if (processedIds.contains(document.id)) {
                continue;
              }
              setState(() {
                messages.add(Message.fromDocument(document));
              });
              break;
            case DocumentChangeType.modified:
              int indexToUpdate =
                  messages.indexWhere((message) => message.id == document.id);
              if (indexToUpdate != -1) {
                setState(() {
                  messages[indexToUpdate] = Message.fromDocument(document);
                });
              }
              break;
            case DocumentChangeType.removed:
              int indexToRemove =
                  messages.indexWhere((message) => message.id == document.id);
              if (indexToRemove != -1) {
                setState(() {
                  messages.removeAt(indexToRemove);
                });
              }
              break;
          }
        }
      });

      messagesLoaded = true;
    } catch (error) {
      throw Exception('Error listening to messages: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return buildHomeScreen(context);
        }
      },
    );
  }

  Widget buildHomeScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildMessagesListView(),
            buildMessageInputArea(),
          ],
        ),
      ),
    );
  }

  Widget buildMessagesListView() {
    return Expanded(
      child: messages.isEmpty && messagesLoaded
          ? const Center(
              child: Text(
                'No messages',
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              shrinkWrap: true,
              itemCount: messages.length,
              itemBuilder: (context, index) =>
                  MessageItem(message: messages[index]),
            ),
    );
  }

  Widget buildMessageInputArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              focusNode: messageFocusNode,
              onSubmitted: (_) {
                sendMessage();
                messageFocusNode.requestFocus();
              },
              decoration: InputDecoration(
                hintText: 'Enter your message',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintStyle: const TextStyle(
                  color: Colors.white,
                ),
                fillColor: Theme.of(context).colorScheme.tertiary,
                filled: true,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 48, // Adjust the height to match the input field's height
            child: CustomButton(
              icon: const Icon(Icons.send),
              onPressed: () async {
                try {
                  await sendMessage();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error sending message: $e')),
                  );
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 48, // Adjust the height to match the input field's height
            child: CustomButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.settingsPage);
              },
            ),
          ),
        ],
      ),
    );
  }
}

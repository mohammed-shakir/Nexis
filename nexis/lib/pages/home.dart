import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../widgets/custom_button.dart';
import '../classes/route_names.dart';
import '../firebase/firestore_write.dart';
import '../firebase/firestore_read.dart';
import '../firebase/login.dart';
import '../classes/message_model.dart';
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

  @override
  void initState() {
    super.initState();
    signIn().then((_) async {
      await listenToMessages();
      setState(() {
        // Update the UI
      });
    }).catchError((error) {
      throw Exception('Failed to sign in: $error');
    });
  }

  // Clean up resources that are no longer needed (messageController). If it is not removed, it could cause a memory leak.
  @override
  void dispose() {
    subscription?.cancel();
    messageController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    try {
      await dotenv.load(fileName: ".env");
      await Login.signIn(
          dotenv.env['TEMP_TEST_EMAIL']!, dotenv.env['TEMP_TEST_PASSWORD']!);
    } catch (e) {
      throw Exception('Error signing in: $e');
    }
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
        FocusScope.of(context).unfocus();
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
          Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
          messages.add(Message(
            id: document.id,
            sender: data?['sender'] as String,
            content: data?['message'] as String,
            timestamp: data?['timestamp'] as Timestamp,
          ));
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
          if (docChange.type == DocumentChangeType.added) {
            DocumentSnapshot newDocument = docChange.doc;
            if (processedIds.contains(newDocument.id)) {
              continue;
            }
            Map<String, dynamic>? data =
                newDocument.data() as Map<String, dynamic>?;
            setState(() {
              // Update the UI here
              messages.add(Message(
                id: newDocument.id,
                sender: data?['sender'] as String,
                content: data?['message'] as String,
                timestamp: data?['timestamp'] as Timestamp,
              ));
            });
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
          : ListView.separated(
              shrinkWrap: true,
              itemCount: messages.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) => buildMessageItem(index),
            ),
    );
  }

  Widget buildMessageItem(int index) {
    final message = messages[index];
    final sender = message.sender;
    final timestamp = message.timestamp.toDate();
    final content = message.content;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              sender,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              timestamp.toString(),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
      ],
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
              onSubmitted: (_) => sendMessage(),
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
          CustomButton(
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
          const SizedBox(width: 10),
          CustomButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.settingsPage);
            },
          ),
        ],
      ),
    );
  }
}

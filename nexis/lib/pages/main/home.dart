import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/message_item.dart';
import '../../widgets/text_input_field.dart';
import '../../firebase/firestore_write.dart';
import '../../firebase/firestore_read.dart';
import '../../models/message_model.dart';
import 'components/channels.dart';
import 'components/participant_info.dart';
import 'components/navbar.dart';
import 'components/servers.dart';
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
  ScrollController scrollController = ScrollController();
  static const int maxMessageLength = 2000;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    initSharedPreferences();

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

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> sendMessage() async {
    String messageContent = messageController.text.trim();

    if (messageContent.isEmpty) {
      return;
    } else if (messageContent.length > maxMessageLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message exceeds maximum length.')),
      );
    } else {
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
                scrollToBottom();
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
      WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
    } catch (error) {
      throw Exception('Error listening to messages: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildHomeScreen(context);
  }

  Widget buildHomeScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Row(
          children: [
            const Expanded(
              flex: 5,
              child: Servers(),
            ),
            const Expanded(
              flex: 15,
              child: Channels(),
            ),
            Expanded(
              flex: 80,
              child: Column(
                children: [
                  const Expanded(
                    flex: 5,
                    child: NavBar(),
                  ),
                  Expanded(
                    flex: 95,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 80,
                          child: Column(children: [
                            buildMessagesListView(),
                            TextInputField(
                              messageController: messageController,
                              messageFocusNode: messageFocusNode,
                              sendMessage: sendMessage,
                              scrollToBottom: scrollToBottom,
                            ),
                          ]),
                        ),
                        const Expanded(
                          flex: 20,
                          child: ParticipantInfo(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
          : Scrollbar(
              thumbVisibility: true,
              controller: scrollController,
              child: ListView.separated(
                controller: scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                shrinkWrap: true,
                itemCount: messages.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) =>
                    MessageItem(message: messages[index]),
              ),
            ),
    );
  }
}

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexis/widgets/input/message_input_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../firebase/firestore_write.dart';
import '../../firebase/firestore_read.dart';
import '../../media/media_share.dart';
import '../../models/message_model.dart';
import 'components/channels.dart';
import 'components/participant_info.dart';
import 'components/navbar.dart';
import 'components/servers.dart';
import 'components/message_interface.dart';
import '../../enums/screen_type.dart';
import '../../tenor/gif_search.dart';
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
  final buttonKey = GlobalKey();
  final gifSearchDialog = const GifSearchDialog();
  List<PlatformFile> files = [];

  @override
  void initState() {
    super.initState();

    initSharedPreferences().then((_) {
      return listenToMessages();
    }).then((_) {
      setState(() {
        // Update the UI
      });
    });
  }

  // Clean up resources that are no longer needed. If it is not removed, it could cause a memory leak.
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
    messageController.clear();
    if (messageContent.isEmpty) {
      return;
    } else if (messageContent.length > maxMessageLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message exceeds maximum length.')),
      );
    } else {
      if (messageContent.isNotEmpty) {
        try {
          String? avatar = prefs.getString('avatar');
          await FirestoreWrite.sendMessage(
            message: messageContent,
            sender: prefs.getString('displayName')!,
            groupChatId: prefs.getStringList('servers')?[0] ?? '',
            avatar: avatar ?? '',
          );
          messageController.clear();
        } catch (e) {
          messageController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error sending message: $e')),
          );
        }
      }
    }
  }

  Future<void> listenToMessages() async {
    FirestoreRead firestoreRead =
        FirestoreRead(groupId: prefs.getStringList('servers')?[0] ?? '');
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
      if (messages.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
      }
    } catch (error) {
      throw Exception('Error listening to messages: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var screenType = getScreenType(mediaQuery);

    switch (screenType) {
      case ScreenType.mobile:
        return buildMobileHomeScreen(context);
      case ScreenType.tablet:
        return buildMobileHomeScreen(context);
      case ScreenType.desktop:
        return buildDesktopHomeScreen(context);
      default:
        return buildDesktopHomeScreen(context);
    }
  }

  Widget buildDesktopHomeScreen(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    const double serversWidth = 75;
    const double channelsWidth = 230;
    const double navbarHeight = 50;
    const double participantInfoWidth = 230;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double maxWidth =
                constraints.maxWidth > 2560 ? 2560 : constraints.maxWidth;
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Row(
                  children: [
                    const SizedBox(
                      width: serversWidth,
                      child: Servers(),
                    ),
                    const SizedBox(
                      width: channelsWidth,
                      child: Channels(),
                    ),
                    SizedBox(
                      width: maxWidth - serversWidth - channelsWidth,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: navbarHeight,
                            child: NavBar(),
                          ),
                          SizedBox(
                            height: screenSize.height - navbarHeight,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(children: [
                                    Expanded(
                                      child: MessageInterface(
                                        messages: messages,
                                        messagesLoaded: messagesLoaded,
                                        scrollController: scrollController,
                                      ),
                                    ),
                                    inputFieldBuilder(),
                                  ]),
                                ),
                                const SizedBox(
                                  width: participantInfoWidth,
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
          },
        ),
      ),
    );
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Widget buildMobileHomeScreen(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.primary,
        endDrawer: const Drawer(
          child: ParticipantInfo(),
        ),
        drawer: const Drawer(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Servers(),
              ),
              Expanded(
                flex: 3,
                child: Channels(),
              ),
            ],
          ),
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: NavBar(
            openDrawer: () => scaffoldKey.currentState?.openDrawer(),
            openEndDrawer: () => scaffoldKey.currentState?.openEndDrawer(),
          ),
        ),
        body: SafeArea(
          child: Column(children: [
            Expanded(
                child: MessageInterface(
              messages: messages,
              messagesLoaded: messagesLoaded,
              scrollController: scrollController,
            )),
            inputFieldBuilder(),
          ]),
        ));
  }

  Widget inputFieldBuilder() {
    return StatefulBuilder(
      builder: (ctx, setState) => MessageInputField(
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
        controller: messageController,
        files: files,
        hint: 'Message',
        onSubmittedMultiline: () async {
          try {
            final List<PlatformFile> sendFiles = [];
            if (files.isNotEmpty) {
              sendFiles.addAll(files);
              files.clear();
            }
            if (messageController.text.isNotEmpty) {
              await sendMessage();
              if (messageController.text.length <= maxMessageLength) {
                scrollToBottom();
                messageFocusNode.requestFocus();
              }
            }
            await MediaShare().uploadFiles(sendFiles, prefs);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error sending message: $e')),
            );
          }
        },
        onPressedEmoji: () {},
        onPressedGif: () async {
          final gifUrl = await Navigator.of(context).push<String>(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (_, __, ___) => const GifSearchDialog(),
            ),
          );

          if (gifUrl != null) {
            messageController.text = gifUrl;
            sendMessage();
          }
        },
        onPressedMedia: () async {
          final file = await MediaShare().selectFile();
          setState(() {
            files.addAll(file ?? []);
            messageFocusNode.requestFocus();
          });
        },
      ),
    );
  }
}

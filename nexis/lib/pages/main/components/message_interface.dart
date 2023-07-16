import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/message_model.dart';
import '../../../widgets/message_item.dart';

class MessageInterface extends StatefulWidget {
  final List<Message> messages;
  final bool messagesLoaded;
  final ScrollController scrollController;

  const MessageInterface({
    Key? key,
    required this.messages,
    required this.messagesLoaded,
    required this.scrollController,
  }) : super(key: key);

  @override
  MessageInterfaceState createState() => MessageInterfaceState();
}

class MessageInterfaceState extends State<MessageInterface> {
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Widget buildMessagesListView() {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: widget.messages.isEmpty && widget.messagesLoaded
          ? const Center(
              child: Text(
                'No messages',
                style: TextStyle(color: Colors.white),
              ),
            )
          : SelectionArea(
              child: Scrollbar(
                thumbVisibility: true,
                controller: widget.scrollController,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ListView.separated(
                    controller: widget.scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    shrinkWrap: true,
                    itemCount: widget.messages.length,
                    separatorBuilder: (context, index) {
                      bool showSenderInfoNext =
                          index + 1 == widget.messages.length ||
                              widget.messages[index + 1].sender !=
                                  widget.messages[index].sender;
                      return SizedBox(height: showSenderInfoNext ? 10 : 5);
                    },
                    itemBuilder: (context, index) {
                      bool showSenderInfo = index == 0 ||
                          widget.messages[index].sender !=
                              widget.messages[index - 1].sender;
                      return MessageItem(
                        message: widget.messages[index],
                        showSenderInfo: showSenderInfo,
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: buildMessagesListView(),
    );
  }
}

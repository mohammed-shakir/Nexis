import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nexis/media/display_media.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/message_model.dart';
import '../classes/time_format.dart';
import '../../widgets/loading_screen.dart';
import 'message_options_menu.dart';

class MessageItem extends StatefulWidget {
  final Message message;
  final bool showSenderInfo;

  const MessageItem(
      {Key? key, required this.message, this.showSenderInfo = true})
      : super(key: key);

  @override
  MessageItemState createState() => MessageItemState();
}

class MessageItemState extends State<MessageItem> {
  bool isHovered = false;
  bool isMenuOpen = false;
  bool isPressed = false;

  Widget _buildContentWidget(BuildContext context, String content) {
    Map<String, Widget Function(BuildContext)> contentBuilders = {
      "https://media.tenor.com": (BuildContext context) => CachedNetworkImage(
            imageUrl: content,
            placeholder: (context, url) => const LoadingIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
          ),
      "https://firebasestorage.googleapis.com/v0/b/nexis-4723a.appspot.com":
          (BuildContext context) => DisplayMedia(
                sender: widget.message.sender,
                messageId: widget.message.id,
                content: content,
              ),
    };

    for (var entry in contentBuilders.entries) {
      if (content.startsWith(entry.key)) {
        return entry.value(context);
      }
    }

    return MarkdownBody(
      data: content,
      selectable: true,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        p: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Colors.white),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.reply),
              title: const Text('Reply'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_reaction),
              title: const Text('Add Reaction'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sender = widget.message.sender;
    final timestamp = widget.message.timestamp.toDate();
    final content = widget.message.content;
    final avatar = widget.message.avatar;
    final formattedTimestamp = TimeFormat.formattedTimestamp(timestamp);

    ImageProvider imageProvider;
    if (avatar.isNotEmpty) {
      imageProvider = NetworkImage(avatar);
    } else {
      imageProvider = const AssetImage("./assets/logo-no-background-icon.png");
    }

    if (!kIsWeb) {
      return Padding(
        padding: widget.showSenderInfo
            ? const EdgeInsets.only(top: 8)
            : const EdgeInsets.only(top: 0),
        child: GestureDetector(
          onLongPress: () {
            _showOptionsMenu(context);
          },
          child: Container(
            color: isPressed
                ? const Color.fromARGB(255, 31, 35, 47)
                : Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.showSenderInfo
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CircleAvatar(
                          backgroundImage: imageProvider,
                          backgroundColor: Colors.transparent,
                          radius: 20,
                        ),
                      )
                    : const SizedBox(width: 48),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.showSenderInfo) ...[
                        Row(
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
                              formattedTimestamp,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                      _buildContentWidget(context, content),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: widget.showSenderInfo
            ? const EdgeInsets.only(top: 8)
            : const EdgeInsets.only(top: 0),
        child: MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: Container(
            color: isHovered || isMenuOpen
                ? const Color.fromARGB(255, 31, 35, 47)
                : Colors.transparent,
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.showSenderInfo
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CircleAvatar(
                              backgroundImage: imageProvider,
                              backgroundColor: Colors.transparent,
                              radius: 20,
                            ),
                          )
                        : const SizedBox(width: 48),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.showSenderInfo) ...[
                            Row(
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
                                  formattedTimestamp,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                          ],
                          _buildContentWidget(context, content),
                        ],
                      ),
                    ),
                  ],
                ),
                if (isHovered || isMenuOpen)
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 8,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: MessageOptionsMenu(
                        isMessageOwner: true,
                        onDelete: () {},
                        onReply: () {},
                        onAddReaction: () {},
                        onMenuToggle: (isOpen) {
                          setState(() {
                            isMenuOpen = isOpen;
                            isHovered = isOpen || isHovered;
                          });
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

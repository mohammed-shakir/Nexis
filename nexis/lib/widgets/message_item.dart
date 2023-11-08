import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nexis/media/display_media.dart';
import '../models/message_model.dart';
import '../classes/time_format.dart';
import '../../widgets/loading_screen.dart';

class MessageItem extends StatelessWidget {
  final Message message;
  final bool showSenderInfo;

  const MessageItem(
      {super.key, required this.message, this.showSenderInfo = true});

  Widget _buildContentWidget(BuildContext context, String content) {
    Map<String, Widget Function(BuildContext)> contentBuilders = {
      "https://media.tenor.com": (BuildContext context) => CachedNetworkImage(
            imageUrl: content,
            placeholder: (context, url) => const LoadingIndicatorFull(),
          ),
      "https://firebasestorage.googleapis.com/v0/b/nexis-4723a.appspot.com":
          (BuildContext context) => DisplayMedia(
                sender: message.sender,
                messageId: message.id,
                content: content,
              ),
    };

    Widget contentWidget = Text(
      content,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w300,
      ),
    );

    for (var entry in contentBuilders.entries) {
      if (content.startsWith(entry.key)) {
        contentWidget = entry.value(context);
        break;
      }
    }

    return contentWidget;
  }

  @override
  Widget build(BuildContext context) {
    final sender = message.sender;
    final timestamp = message.timestamp.toDate();
    final content = message.content;
    final avatar = message.avatar;

    final formattedTimestamp = TimeFormat.formattedTimestamp(timestamp);

    ImageProvider imageProvider;
    if (avatar.isNotEmpty) {
      imageProvider = NetworkImage(avatar);
    } else {
      imageProvider = const AssetImage("./assets/logo-no-background-icon.png");
    }

    return Padding(
      padding: showSenderInfo
          ? const EdgeInsets.only(top: 8)
          : const EdgeInsets.only(top: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showSenderInfo
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
                if (showSenderInfo) ...[
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
    );
  }
}

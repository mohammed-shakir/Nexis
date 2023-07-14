import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/message_model.dart';
import '../classes/time_format.dart';
import '../../widgets/loading_screen.dart';

class MessageItem extends StatelessWidget {
  final Message message;

  const MessageItem({super.key, required this.message});

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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundImage: imageProvider,
              backgroundColor: Colors.transparent,
              radius: 20,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                content.startsWith("https://media.tenor.com")
                    ? CachedNetworkImage(
                        imageUrl: content,
                        placeholder: (context, url) => const LoadingIndicator(),
                      )
                    : Text(
                        content,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

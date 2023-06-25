import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../classes/time_format.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MessageItem extends StatelessWidget {
  final Message message;

  const MessageItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final sender = message.sender;
    final timestamp = message.timestamp.toDate();
    final content = message.content;

    final formattedTimestamp = TimeFormat.formattedTimestamp(timestamp);

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
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
              )
            : Text(
                content,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
        const SizedBox(height: 8),
      ],
    );
  }
}

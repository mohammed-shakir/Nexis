import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String sender;
  final String content;
  final Timestamp timestamp;

  Message({
    required this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
  })  : assert(sender.isNotEmpty, 'Sender must not be empty'),
        assert(content.trim().isNotEmpty,
            'Content must have at least one non-whitespace character');

  factory Message.fromDocument(DocumentSnapshot document) {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    return Message(
      id: document.id,
      sender: data?['sender'] as String? ?? '',
      content: data?['message'] as String? ?? '',
      timestamp: data?['timestamp'] as Timestamp? ?? Timestamp.now(),
    );
  }
}

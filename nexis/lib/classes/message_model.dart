import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String sender;
  final String content;
  final Timestamp timestamp;

  Message(
      {required this.id,
      required this.sender,
      required this.content,
      required this.timestamp});
}

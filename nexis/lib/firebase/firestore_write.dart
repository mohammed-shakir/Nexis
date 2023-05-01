import 'package:firedart/firedart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';

class FirestoreWrite {
  static final Firestore firestore = Firestore.instance;
  static final FirebaseFirestore firestoreWeb = FirebaseFirestore.instance;

  static Future<void> sendMessage({
    required String message,
    required String sender,
    required String conversationId,
    DateTime? createdAt,
  }) async {
    DateTime timestamp = createdAt ?? DateTime.now();

    try {
      if (kIsWeb) {
        await firestoreWeb.collection('messages').add({
          'content': message,
          'sender': sender,
          'conversationId': conversationId,
          'createdAt': timestamp,
          'type': 'text',
        });
      } else {
        await firestore.collection('messages').add({
          'content': message,
          'sender': sender,
          'conversationId': conversationId,
          'createdAt': timestamp,
          'type': 'text',
        });
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}

/*
class FirestoreWrite {
  static final Firestore firestore = Firestore.instance;
  static final FirebaseFirestore firestoreWeb = FirebaseFirestore.instance;

  static Future<void> sendMessage({
    required String message,
    required String sender,
    DateTime? timestamp,
  }) async {
    String formattedTimestamp = DateFormat('dd/MM/yyyy HH:mm').format(timestamp ?? DateTime.now());

    try {
      if (kIsWeb) {
        await firestoreWeb.collection('messages').add({
          'message': message,
          'sender': sender,
          'timestamp': formattedTimestamp,
        });
      } else {
        await firestore.collection('messages').add({
          'message': message,
          'sender': sender,
          'timestamp': formattedTimestamp,
        });
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}
*/
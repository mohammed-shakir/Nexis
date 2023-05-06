import 'package:firedart/firedart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:intl/intl.dart';

class FirestoreWrite {
  static final Firestore firestore = Firestore.instance;
  static final FirebaseFirestore firestoreWeb = FirebaseFirestore.instance;

  static Future<void> sendMessage({
    required String message,
    required String sender,
    required String groupChatId,
    DateTime? createdAt,
  }) async {
    DateTime timestamp = createdAt ?? DateTime.now();
    // String formattedTimestamp = DateFormat('dd/MM/yyyy HH:mm').format(timestamp ?? DateTime.now());
    // 'timestamp': formattedTimestamp,

    try {
      if (kIsWeb) {
        await firestoreWeb.collection('group_chats').doc(groupChatId).collection('messages').add({
          'message': message,
          'sender': sender,
          'createdAt': timestamp,
        });
      } else {
        await firestore.collection('group_chats').document(groupChatId).collection('messages').add({
          'message': message,
          'sender': sender,
          'createdAt': timestamp,
        });
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}

import 'package:firedart/firedart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class FirestoreWrite {
  static final Firestore firestore = Firestore.instance;
  static final FirebaseFirestore firestoreWeb = FirebaseFirestore.instance;

  static Future<void> sendMessage({
    required String message,
    required String sender,
    required String groupChatId,
    required String avatar,
    DateTime? createdAt,
  }) async {
    DateTime timestamp = createdAt ?? DateTime.now();

    try {
      if (kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
        await firestoreWeb
            .collection('group_chats')
            .doc(groupChatId)
            .collection('messages')
            .add({
          'message': message,
          'sender': sender,
          'timestamp': timestamp,
          'avatar': avatar,
        });
      } else if (Platform.isWindows || Platform.isLinux) {
        await firestore
            .collection('group_chats')
            .document(groupChatId)
            .collection('messages')
            .add({
          'message': message,
          'sender': sender,
          'timestamp': timestamp,
          'avatar': avatar,
        });
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}

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

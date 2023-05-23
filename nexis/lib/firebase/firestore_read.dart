import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:logger/logger.dart';
import 'dart:async';

class FirestoreRead {
  final String groupId;
  final CollectionReference messagesCollection;
  Stream<QuerySnapshot>? querySnapshotStream;
  static final logger = Logger();

  FirestoreRead({required this.groupId})
      : messagesCollection = FirebaseFirestore.instance
            .collection('group_chats')
            .doc(groupId)
            .collection('messages') {
    try {
      if (kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
        querySnapshotStream = messagesCollection.snapshots();
      } else if (Platform.isWindows || Platform.isLinux) {
        logger.i('FirestoreRead: Platform is Windows or Linux');
      }
    } catch (e) {
      throw Exception('Failed to read messages: $e');
    }
  }

  Future<List<DocumentSnapshot>> initialFetch() async {
    QuerySnapshot initialSnapshot = await messagesCollection
        .orderBy('timestamp', descending: true)
        .limit(1) //TODO: Change to something higher on release
        .get();

    return initialSnapshot.docs;
  }

  Stream<QuerySnapshot> listenToNewMessages(Timestamp? lastMessageTimestamp) {
    if (lastMessageTimestamp != null) {
      return messagesCollection
          .orderBy('timestamp')
          .startAfter([lastMessageTimestamp]).snapshots();
    } else {
      // If there's no last message timestamp (collection was initially empty)
      return messagesCollection.orderBy('timestamp').snapshots();
    }
  }
}

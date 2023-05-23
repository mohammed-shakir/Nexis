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

// listenToMessages() for win/lin using firedart in home.dart:
/*
firestoreRead = FirestoreRead();
firestoreRead.collectionStream.listen((documents) {
  // Do something with the updated documents here if needed
  
  setState(() {
    // Update the UI here

  });
});
*/

// firestore_read.dart for win/lin using firedart:
/*
import 'package:firedart/firedart.dart';

static final Firestore firestore = Firestore.instance;
late StreamSubscription<List<Document>> subscription;
static final logger = Logger();

FirestoreRead() {
  subscription = read().listen((documents) {
    // Do something with the updated documents here if needed
    logger.i('Document updated: ${documents.last}');
  });
}

Stream<List<Document>> read() {
  var ref = firestore
      .collection('group_chats')
      .document('aNAgqEvRvtFLDmjw7Ivz')
      .collection('messages');

  return ref.stream;
}

Stream<List<Document>> get collectionStream => read();

Future<void> cancel() async {
  await subscription.cancel();
}
*/

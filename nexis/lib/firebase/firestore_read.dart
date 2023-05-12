import 'package:firedart/firedart.dart';
import 'package:logger/logger.dart';
import 'dart:async';

class FirestoreRead {
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
}

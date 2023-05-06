import 'package:firedart/firedart.dart';
import 'package:logger/logger.dart';

class FirestoreRead {
  static final Firestore firestore = Firestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final logger = Logger();

  static Future<void> signIn(String email, String password) async {
    try {
      await auth.signIn(email, password);
      logger.i("Signed in successfully");
    } catch (e) {
      logger.i("Failed to sign in: $e");
    }
  }

  static CollectionReference getDirectMessagesReference(String user1Id, String user2Id) {
    final directMessagesRef = firestore.collection('direct_messages').document(user1Id);
    return directMessagesRef.collection(user2Id);
  }

  static CollectionReference getGroupChatMessagesReference(String groupChatId) {
    final groupChatsRef = firestore.collection('group_chats');
    final groupChatDocRef = groupChatsRef.document(groupChatId);
    return groupChatDocRef.collection('messages');
  }

  static Stream<List<Document>> listenToMessages({required bool isGroupChat, String? groupChatId, String? user1Id, String? user2Id}) {
    CollectionReference messagesRef;
    if (isGroupChat) {
      messagesRef = getGroupChatMessagesReference(groupChatId!);
    } else {
      messagesRef = getDirectMessagesReference(user1Id!, user2Id!);
    }

    return messagesRef.stream.map((querySnapshot) => querySnapshot);
  }
}

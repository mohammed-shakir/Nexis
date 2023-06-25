import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServerProvider with ChangeNotifier {
  Map<String, Map<String, dynamic>> serverData = {};

  Future<Map<String, dynamic>?> fetchServerData(String serverId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var doc = await firestore.collection('group_chats').doc(serverId).get();

    if (doc.exists) {
      var data = doc.data() as Map<String, dynamic>;
      serverData[serverId] = data;
      notifyListeners();

      return data;
    }
    return null;
  }
}

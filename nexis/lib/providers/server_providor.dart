import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServerProvider with ChangeNotifier {
  Map<String, Map<String, dynamic>> serverData = {};
  String? _selectedServerId;
  String? get selectedServerId => _selectedServerId;
  List<String>? serverChannels = [];
  List<String>? get getServerChannels => serverChannels;

  void setSelectServer(String id) {
    _selectedServerId = id;
    notifyListeners();
  }

  Future<Map<String, dynamic>> fetchServerData(String serverId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var doc = await firestore.collection('group_chats').doc(serverId).get();

    if (doc.exists) {
      var data = doc.data() as Map<String, dynamic>;
      serverData[serverId] = data;
      notifyListeners();

      return data;
    }
    return {};
  }

  Future<Map<String, dynamic>> fetchServerDataUsingId(String id) async {
    int index = int.parse(id);

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('group_chats')
        .where('id', isEqualTo: index)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      var data = doc.data() as Map<String, dynamic>;
      serverData[doc.id] = data;
      notifyListeners();

      return data;
    }

    return {};
  }

  Future<List<String>> fetchServerChannels(String id) async {
    int index = int.parse(id);

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('group_chats')
        .where('id', isEqualTo: index)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      var data = doc.data() as Map<String, dynamic>;
      serverData[doc.id] = data;
      notifyListeners();

      List<String>? channels = data['channels']?.cast<String>();
      return channels ?? [];
    }

    return [];
  }

  void setChannels(String id) async {
    int index = int.parse(id);

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('group_chats')
        .where('id', isEqualTo: index)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      var data = doc.data() as Map<String, dynamic>;
      serverData[doc.id] = data;
      notifyListeners();

      serverChannels = data['channels']?.cast<String>();
    }
  }
}

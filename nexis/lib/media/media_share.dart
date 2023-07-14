import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'file_data.dart';

class MediaShare {
  late UploadTask? uploadTask;
  static final FirebaseFirestore firestoreWeb = FirebaseFirestore.instance;

  Future uploadFiles(List<PlatformFile> files, SharedPreferences prefs) async {
    try {
      for (PlatformFile element in files) {
        final Uint8List? data = element.bytes;
        final String fileName = element.name;
        final type = getMimeType(fileName);

        String id = FirebaseFirestore.instance
          .collection('group_chats')
          .doc('aNAgqEvRvtFLDmjw7Ivz')
          .collection('messages')
          .doc().id;

        final String user = prefs.getString('displayName')!;

        final ref = FirebaseStorage.instance.ref().child('media_share/$user/$id/$fileName');
        uploadTask = ref.putData(data!, SettableMetadata(
          contentType: type,
        ));

        final snapshot = await uploadTask!.whenComplete(() {});
        final downloadURL = await snapshot.ref.getDownloadURL();

        sendMedia(prefs, downloadURL, id);
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<void> sendMedia(SharedPreferences prefs, String downloadURL, String id) async {
    try {
      String? avatar = prefs.getString('avatar');
      DateTime timestamp = DateTime.now();
      var instance = firestoreWeb
            .collection('group_chats')
            .doc('aNAgqEvRvtFLDmjw7Ivz')
            .collection('messages');

      await instance.doc(id).set({
          'message': downloadURL,
          'sender': prefs.getString('displayName')!,
          'timestamp': timestamp,
          'avatar': avatar ?? '',
        });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<PlatformFile>?> selectFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );

      if (result == null) return null;

      return result.files;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}

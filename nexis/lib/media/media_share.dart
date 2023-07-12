import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';

class MediaShare {
  late UploadTask? uploadTask;

  String getFileType(String ext) {
    String? mimeType = lookupMimeType(ext);
    List<String> types = mimeType!.split('/');
    String type = types[0]; // 'image' or 'audio'
    String subtype = types[1]; // 'png' or 'mp3'

    return '$type/$subtype';
  }

  Future uploadFiles(List<PlatformFile> files) async {
    try {
      for (PlatformFile element in files) {
        final Uint8List? data = element.bytes;
        final String fileName = element.name;
        //final ext = element.extension!.toLowerCase();
        final type = getFileType(fileName);
        print(fileName);

        final ref = FirebaseStorage.instance.ref().child('media_share/$fileName');
        uploadTask = ref.putData(data!, SettableMetadata(
          contentType: type,
        ));

        await uploadTask!.whenComplete(() {});
        //final snapshot = await uploadTask!.whenComplete(() {});
        //final downloadURL = await snapshot.ref.getDownloadURL();
      }
    } on Exception catch (e) {
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

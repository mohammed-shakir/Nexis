import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class MediaShare {
  late UploadTask? uploadTask;

  static const imageFileExts = [
    'gif',
    'jpg',
    'jpeg',
    'png',
    'webp',
    'bmp',
    'dib',
    'wbmp',
  ];

  String getFileType(String ext) {
    if (imageFileExts.contains(ext)) {
      return 'image/$ext';
    }

    switch (ext) {
      default:
        return 'application/octet-stream';
    }
  }

  Future uploadFiles(List<PlatformFile> files) async {
    try {
      for (PlatformFile element in files) {
        final Uint8List? data = element.bytes;
        final String fileName = element.name;
        final ext = element.extension!.toLowerCase();
        final type = getFileType(ext);

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

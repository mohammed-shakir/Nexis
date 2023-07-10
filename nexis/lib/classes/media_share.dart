import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class MediaShare{
  late UploadTask? uploadTask;

  Future<String?> uploadFile(Uint8List? file, String? fileName) async {
    final ref = FirebaseStorage.instance.ref().child('files/$fileName');
    uploadTask = ref.putData(file!, SettableMetadata(
      contentType: 'image/png',
    ));

    final snapshot = await uploadTask!.whenComplete(() {});
    final downloadURL = await snapshot.ref.getDownloadURL();

    return downloadURL;
  }

  Future<PlatformFile?> selectFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result == null) return null;

    return result.files.single;
  }
}
import 'package:mime/mime.dart';
import 'package:file_icon/file_icon.dart';

List<String> getFileType(String fileName) {
  String? mimeType = lookupMimeType(fileName);
  List<String> types = mimeType!.split('/');

  return types;
}

String getMimeType(String fileName) {
  String? mimeType = lookupMimeType(fileName);
  return mimeType!;
}

FileIcon getIcon(String fileName) {
  return FileIcon(fileName, size: 112);
}

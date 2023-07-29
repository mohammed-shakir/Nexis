import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'file_data.dart';

class DisplayMedia extends StatefulWidget {
  final String sender;
  final String messageId;
  final String content;
  const DisplayMedia({
    Key? key,
    required this.sender,
    required this.messageId,
    required this.content,
  }) : super(key: key);

  @override
  State<DisplayMedia> createState() => DisplayMediaState();
}

class DisplayMediaState extends State<DisplayMedia> {
  late String fileName = '';

  Future fetchMedia() async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("media_share/${widget.sender}/${widget.messageId}");
    final listResult = await storageRef.listAll();
    List<String> filePath = listResult.items[0].fullPath.split('/');
    fileName = filePath.last;
  }

  @override
  Widget build(BuildContext context) {
    /*return FutureBuilder<void>(
      future: fetchMedia(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return buildFile();
        } else {
          return SizedBox(
            height: 180,
            width: 180,
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          );
        }
      },
    );*/
    return buildFile();
  }

  getFileName() {
    String str = widget.content.substring(
        widget.content.indexOf(widget.messageId) + widget.messageId.length + 3,
        widget.content.indexOf('?alt='));
    return str;
  }

  Widget buildFile() {
    return Container(
      height: 180,
      width: 180,
      alignment: Alignment.center,
      child: ListView(
        children: [
          Container(
            height: 160,
            width: 160,
            alignment: Alignment.center,
            child: (getFileType(getFileName())[0] == 'image')
                ? Image.network(widget.content, fit: BoxFit.cover)
                : Container(
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    child: getIcon(getFileName()),
                  ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            width: double.infinity,
            color: Colors.transparent,
            child: Text(
              getFileName(),
              style: const TextStyle(
                fontWeight: FontWeight.w100,
                color: Colors.white,
                fontFamily: 'Arial',
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

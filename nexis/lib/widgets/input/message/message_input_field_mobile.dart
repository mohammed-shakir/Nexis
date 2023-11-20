import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nexis/widgets/input/base_input_field.dart';
import '../../../media/media_attachment.dart';

class MessageInputFieldMobile extends BaseInputField {
  final TextEditingController controller;
  final List<PlatformFile> files;
  final void Function() onSubmittedMultiline;
  final void Function() onPressedSend;
  final void Function() onPressedMedia;
  final Color? fillColor;
  final String? hint;
  const MessageInputFieldMobile({
    Key? key,
    required this.controller,
    required this.files,
    required this.onSubmittedMultiline,
    required this.onPressedSend,
    required this.onPressedMedia,
    this.fillColor,
    this.hint,
  }) : super(key: key);

  @override
  OutlineInputBorder buildBorder([context, color]) {
    return OutlineInputBorder(
      borderRadius: files.isEmpty
          ? BorderRadius.circular(8.0)
          : const BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0)),
      borderSide: BorderSide.none,
    );
  }

  @override
  MessageInputFieldMobileState createState() => MessageInputFieldMobileState();
}

class MessageInputFieldMobileState extends BaseInputFieldState<MessageInputFieldMobile> {
  late bool sendIconHover = false;
  late bool mediaIconHover = false;

  void multilineKeyEvent(event) {
    if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
      if (!event.isShiftPressed) {
        setState(() {
          widget.onSubmittedMultiline();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: multilineKeyEvent,
        child: Container(
            padding: const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 30.0),
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Column(children: [
              if (widget.files.isNotEmpty)
                StatefulBuilder(
                  builder: (ctx, set) => FileViewer(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: widget.fillColor ?? Colors.blueGrey[750],
                      labelStyle: Theme.of(context).textTheme.bodyLarge,
                    ),
                    files: widget.files,
                    updateState: () {
                      setState(() {});
                    },
                  ),
                ),
              Stack(
                children: [
                  textFormField(
                    controller: widget.controller,
                    contentPadding: const EdgeInsets.only(
                        right: 40.0, left: 45.0, top: 10.0, bottom: 10.0),
                    fillColor: widget.fillColor,
                    maxLines: 15,
                    hint: widget.hint,
                    keyboardType: TextInputType.multiline,
                  ),
                  Positioned(
                    right: 0,
                    child: mouseRegionSend(),
                  ),
                  Positioned(
                    left: 0,
                    child: mouseRegionMedia(),
                  ),
                ],
              )
            ])));
  }

  Widget mouseRegionSend() {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          sendIconHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          sendIconHover = false;
        });
      },
      child: IconButton(
        iconSize: 30.0,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Icon(
          Icons.send,
          color: setColor(sendIconHover),
        ),
        onPressed: widget.onPressedSend,
      ),
    );
  }

  Widget mouseRegionMedia() {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          mediaIconHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          mediaIconHover = false;
        });
      },
      child: IconButton(
        iconSize: 30.0,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Icon(
          Icons.add_box_rounded,
          color: setColor(mediaIconHover),
        ),
        onPressed: widget.onPressedMedia,
      ),
    );
  }
}
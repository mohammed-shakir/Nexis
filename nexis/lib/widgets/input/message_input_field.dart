import 'package:flutter/material.dart';
import 'package:nexis/widgets/input/base_input_field.dart';

class MessageInputField extends BaseInputField {
  final TextEditingController controller;
  const MessageInputField({
    Key? key,
    required this.controller,
  }) : super(key: key, focusBorderColor: const Color(0xFF800020));

  @override
  MessageInputFieldState createState() => MessageInputFieldState();
}

class MessageInputFieldState extends BaseInputFieldState<MessageInputField> {
  late bool emojiIconHover = false;
  late bool gifIconHover = false;
  late bool mediaIconHover = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        textFormField(
          controller: widget.controller,
          contentPadding: const EdgeInsets.only(
              right: 40.0, left: 40.0, top: 10.0, bottom: 10.0),
        ),
        // Positioned Emoji Icon (Right)
        Positioned(
          right: 0,
          child: mouseRegionEmoji(),
        ),
        // Positioned Gif Icon (Further Right)
        Positioned(
          right: 40.0, // Adjust as needed for proper spacing
          child: mouseRegionGif(),
        ),
        // Positioned Media Icon (Left)
        Positioned(
          left: 0,
          child: mouseRegionMedia(),
        ),
      ],
    );
  }

  Widget mouseRegionEmoji() {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          emojiIconHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          emojiIconHover = false;
        });
      },
      child: IconButton(
        icon: Icon(
          Icons.emoji_emotions,
          size: 30.0,
          color: setColor(emojiIconHover),
        ),
        onPressed: () {
          // Emoji icon action
        },
      ),
    );
  }

  Widget mouseRegionGif() {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          gifIconHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          gifIconHover = false;
        });
      },
      child: IconButton(
        icon: Icon(
          Icons.gif_box_rounded,
          size: 30.0,
          color: setColor(gifIconHover),
        ),
        onPressed: () {
          // Gif icon action
        },
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
        icon: Icon(
          Icons.add_box_rounded,
          size: 30.0,
          color: setColor(mediaIconHover),
        ),
        onPressed: () {
          // Media icon action
        },
      ),
    );
  }
}

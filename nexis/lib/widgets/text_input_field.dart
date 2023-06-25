import 'package:flutter/material.dart';
import 'package:nexis/tenor/gif_search.dart';
import '../widgets/custom_button.dart';
import '../classes/route_names.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController messageController;
  final FocusNode messageFocusNode;
  final Function sendMessage;
  final Function scrollToBottom;
  final GlobalKey buttonKey;
  final GifSearchDialog gifSearchDialog;
  const TextInputField({
    super.key,
    required this.messageController,
    required this.messageFocusNode,
    required this.sendMessage,
    required this.scrollToBottom,
    required this.buttonKey,
    required this.gifSearchDialog,
  });

  static const int maxMessageLength = 2000;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              focusNode: messageFocusNode,
              onSubmitted: (_) {
                try {
                  if (messageController.text.isNotEmpty) {
                    sendMessage();
                    scrollToBottom();
                    messageFocusNode.requestFocus();
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error sending message: $e')),
                  );
                }
              },
              decoration: InputDecoration(
                hintText: 'Enter your message',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintStyle: const TextStyle(
                  color: Colors.white,
                ),
                fillColor: Theme.of(context).colorScheme.tertiary,
                filled: true,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 48,
            child: CustomButton(
              icon: const Icon(Icons.send),
              onPressed: () async {
                try {
                  if (messageController.text.isNotEmpty) {
                    await sendMessage();
                    if (messageController.text.length <= maxMessageLength) {
                      scrollToBottom();
                      messageFocusNode.requestFocus();
                    }
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error sending message: $e')),
                  );
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 48,
            child: CustomButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.settingsPage);
              },
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 48, // Adjust the height to match the input field's height
            child: CustomButton(
              key: buttonKey,
              text: "GIF",
              onPressed: () async {
                final buttonRenderBox =
                    buttonKey.currentContext!.findRenderObject() as RenderBox;
                final buttonPosition =
                    buttonRenderBox.localToGlobal(Offset.zero);

                final gifUrl = await Navigator.of(context).push<String>(
                  PageRouteBuilder(
                    opaque:
                        false, // set to false so that the main screen can be seen beneath
                    pageBuilder: (_, __, ___) =>
                        GifSearchDialog(buttonPosition),
                  ),
                );

                if (gifUrl != null) {
                  messageController.text = gifUrl;
                  sendMessage();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

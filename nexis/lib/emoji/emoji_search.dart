import 'package:flutter/material.dart';

class EmojiSearchDialog extends StatefulWidget {
  const EmojiSearchDialog({Key? key}) : super(key: key);

  @override
  EmojiSearchDialogState createState() => EmojiSearchDialogState();
}

class EmojiSearchDialogState extends State<EmojiSearchDialog> {
  final List<String> emojis = ["😀", "😂", "👍", "❤️", "😎", "😢", "🔥", "🎉", "😅", "🙈"];
  int hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9,
          childAspectRatio: 1,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: emojis.length,
        itemBuilder: (context, index) {
          return MouseRegion(
            onEnter: (_) => setState(() => hoveredIndex = index),
            onExit: (_) => setState(() => hoveredIndex = -1),
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => Navigator.pop(context, emojis[index]),
              child: Container(
                decoration: BoxDecoration(
                  color: hoveredIndex == index ? Colors.grey[300] : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  emojis[index],
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

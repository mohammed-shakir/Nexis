import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class EmojiSearchDialog extends StatefulWidget {
  const EmojiSearchDialog({Key? key}) : super(key: key);

  @override
  EmojiSearchDialogState createState() => EmojiSearchDialogState();
}

class EmojiSearchDialogState extends State<EmojiSearchDialog> {
  late Future<Map<String, List<String>>> emojiCategoriesFuture;
  String hoveredEmoji = '';

  @override
  void initState() {
    super.initState();
    emojiCategoriesFuture = loadEmojiCategories();
  }

  Future<Map<String, List<String>>> loadEmojiCategories() async {
    String jsonString = await rootBundle.loadString('assets/emojis.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    Map<String, List<String>> categories = {};
    jsonMap.forEach((key, value) {
      categories[key] = List<String>.from(value);
    });
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<String>>>(
      future: emojiCategoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading emojis"));
          }

          if (snapshot.hasData) {
            return buildEmojiCategories(snapshot.data!);
          }
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildEmojiCategories(Map<String, List<String>> emojiCategories) {
    List<Widget> slivers = [];
    const double horizontalPadding = 8.0;

    emojiCategories.forEach((category, emojis) {
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: horizontalPadding, top: 8.0, bottom: 8.0),
            child: Text(
              category,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 9,
              childAspectRatio: 1,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                String emoji = emojis[index];
                return EmojiWidget(emoji: emoji);
              },
              childCount: emojis.length,
            ),
          ),
        ),
      );
    });

    return Expanded(
      child: CustomScrollView(
        slivers: slivers,
      ),
    );
  }
}

class EmojiWidget extends StatefulWidget {
  final String emoji;
  const EmojiWidget({Key? key, required this.emoji}) : super(key: key);

  @override
  EmojiWidgetState createState() => EmojiWidgetState();
}

class EmojiWidgetState extends State<EmojiWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.pop(context, widget.emoji),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isHovered ? Colors.grey[300] : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.emoji,
            style: const TextStyle(fontSize: 28),
          ),
        ),
      ),
    );
  }
}
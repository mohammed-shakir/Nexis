import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class EmojiSearchDialog extends StatefulWidget {
  final String searchQuery;

  const EmojiSearchDialog({Key? key, required this.searchQuery}) : super(key: key);

  @override
  EmojiSearchDialogState createState() => EmojiSearchDialogState();
}

class EmojiSearchDialogState extends State<EmojiSearchDialog> {
  late Future<Map<String, List<Map<String, dynamic>>>> emojiCategoriesFuture;

  @override
  void initState() {
    super.initState();
    emojiCategoriesFuture = loadEmojiCategories();
  }

  Future<Map<String, List<Map<String, dynamic>>>> loadEmojiCategories() async {
    String jsonString = await rootBundle.loadString('assets/emojis.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    Map<String, List<Map<String, dynamic>>> categories = {};
    jsonMap['categories'].forEach((key, value) {
      categories[key] = List<Map<String, dynamic>>.from(value);
    });
    return categories;
  }

  Map<String, List<Map<String, dynamic>>> filterEmojis(Map<String, List<Map<String, dynamic>>> categories) {
    if (widget.searchQuery.isEmpty) return categories;

    Map<String, List<Map<String, dynamic>>> filteredCategories = {};
    categories.forEach((category, emojiList) {
      List<Map<String, dynamic>> filteredList = emojiList.where((emojiData) {
        return (emojiData['keywords'] as List).any((keyword) => keyword.toString().contains(widget.searchQuery));
      }).toList();

      if (filteredList.isNotEmpty) {
        filteredCategories[category] = filteredList;
      }
    });

    return filteredCategories;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
      future: emojiCategoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading emojis"));
          }

          if (snapshot.hasData) {
            var filteredData = filterEmojis(snapshot.data!);
            return buildEmojiCategories(filteredData);
          }
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildEmojiCategories(Map<String, List<Map<String, dynamic>>> emojiCategories) {
    List<Widget> slivers = [];
    const double horizontalPadding = 14.0;

    emojiCategories.forEach((category, emojis) {
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
              left: horizontalPadding,
              top: 8.0,
              bottom: 8.0
            ),
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
                Map<String, dynamic> emojiData = emojis[index];
                return EmojiWidget(emojiData: emojiData);
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
  final Map<String, dynamic> emojiData;

  const EmojiWidget({Key? key, required this.emojiData}) : super(key: key);

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
        onTap: () => Navigator.pop(context, widget.emojiData['emoji']),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isHovered ? Theme.of(context).colorScheme.surfaceVariant : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.emojiData['emoji'],
            style: const TextStyle(fontSize: 28),
          ),
        ),
      ),
    );
  }
}
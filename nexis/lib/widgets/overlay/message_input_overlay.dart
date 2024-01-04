import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nexis/emoji/emoji_search.dart';
import 'package:nexis/tenor/gif_search.dart';
import 'package:nexis/widgets/input/search_input_field.dart';
import 'package:nexis/widgets/overlay/utils/select_button.dart';
import '../../enums/screen_type.dart';

class MessageInputOverlay extends StatefulWidget {
  final Type initialType;

  const MessageInputOverlay({Key? key, required this.initialType}) : super(key: key);

  @override
  MessageInputOverlayState createState() => MessageInputOverlayState();
}

class MessageInputOverlayState extends State<MessageInputOverlay> {
  Type? type;
  Type? selectedType;

  BuildContext? overlayContext;
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<GifSearchDialogState> childkey = GlobalKey<GifSearchDialogState>();

  OverlayEntry? overlayEntry;
  Timer? _debounce;
  final ValueNotifier<String> emojiSearchQuery = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    type = widget.initialType;
    selectedType = widget.initialType;
    overlayEntry = OverlayEntry(builder: (context) {
      overlayContext = context;
      return buildOverlay(context);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => showOverlay());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    if (overlayEntry?.mounted ?? false) {
      overlayEntry?.remove();
    }
    super.dispose();
  }

  void refreshOverlay() {
    if (overlayContext != null) {
      final overlay = Overlay.of(overlayContext!);
      overlay.setState(() {});
    }
  }

  void showOverlay() {
    Overlay.of(context).insert(overlayEntry!);
  }

  void _onChange(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      if (type == Type.emoji) {
        emojiSearchQuery.value = value.toLowerCase();
      } else if (type == Type.gif) {
        childkey.currentState?.fetchGifs(value);
      }
    });
  }

  Widget buildOverlay(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var screenType = getScreenType(mediaQuery);

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              if (overlayEntry?.mounted ?? false) {
                overlayEntry?.remove();
              }
              Navigator.pop(context);
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        Positioned(
          right: screenType == ScreenType.desktop ? 265.0 : 15,
          bottom: 90,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: screenType == ScreenType.mobile ? mediaQuery.size.width - 20 : 450,
              height: (mediaQuery.size.height - 130).clamp(0, 500),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.background,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 8.0, 0.0, 4.0),
                    child: Row(
                      children: [
                        selectButton(context, Type.gif, "GIFs"),
                        selectButton(context, Type.emoji, "Emoji"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 8.0),
                    child: SizedBox(
                      height: 40,
                      child: SearchInputField(
                        fillColor: Theme.of(context).colorScheme.surfaceVariant,
                        controller: searchController,
                        hint: getTypeInfo(type ?? Type.gif),
                        onChanged: _onChange,
                      ),
                    ),
                  ),
                  const Divider(thickness: 0.4, color: Colors.black),
                  const SizedBox(height: 10),
                  getTypeWidget(type ?? Type.gif),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget selectButton(BuildContext context, Type type, String name) {
    bool isSelected = selectedType == type;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
      child: SelectButton(
        text: name,
        color: isSelected ? Colors.white : Colors.grey,
        backgroundColor: isSelected ? Colors.transparent : Theme.of(context).colorScheme.background,
        pressedBackgroundColor: Colors.transparent,
        pressedTextColor: Colors.white,
        hoverTextColor: Colors.white,
        onPressed: () {
          setState(() {
            selectedType = isSelected ? null : type;
            this.type = type;
          });
          refreshOverlay();
        },
      ),
    );
  }

  String getTypeInfo(Type type) {
    if (type == Type.gif) {
      return 'Search Tenor';
    } else if (type == Type.emoji) {
      return 'Search Emoji';
    } else {
      return '';
    }
  }

  Widget getTypeWidget(Type type) {
    if (type == Type.gif) {
      return GifSearchDialog(key: childkey);
    } else if (type == Type.emoji) {
      return ValueListenableBuilder<String>(
        valueListenable: emojiSearchQuery,
        builder: (context, value, _) {
          return EmojiSearchDialog(searchQuery: value);
        },
      );
    } else {
      return const SizedBox();
    }
  }
}

enum Type {
  gif,
  emoji,
}

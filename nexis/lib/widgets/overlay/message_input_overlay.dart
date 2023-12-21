import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nexis/emoji/emoji_search.dart';
import 'package:nexis/tenor/gif_search.dart';
import 'package:nexis/widgets/custom_button.dart';
import 'package:nexis/widgets/input/search_input_field.dart';
import '../../enums/screen_type.dart';

class MessageInputOverlay extends StatefulWidget {
  const MessageInputOverlay({Key? key}) : super(key: key);

  @override
  MessageInputOverlayState createState() => MessageInputOverlayState();
}

class MessageInputOverlayState extends State<MessageInputOverlay> {
  Type? type;

  BuildContext? overlayContext;
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<GifSearchDialogState> childkey =
      GlobalKey<GifSearchDialogState>();

  OverlayEntry? overlayEntry;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
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
    _debounce = Timer(const Duration(milliseconds: 500), () {
      childkey.currentState?.fetchGifs(value);
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
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: screenType == ScreenType.mobile
                  ? mediaQuery.size.width - 20
                  : 450,
              height: (mediaQuery.size.height - 130).clamp(0, 500),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.background,
                border: Border.all(color: Colors.transparent),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 12.0, 0.0, 8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
                          child: SizedBox(
                            child: CustomButton(
                              backgroundColor:
                                  Theme.of(context).colorScheme.background,
                              text: "GIFs",
                              onPressed: (() async {
                                setState(() {
                                  type = Type.gif;
                                });
                                refreshOverlay();
                              }),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
                          child: SizedBox(
                            child: CustomButton(
                              backgroundColor:
                                  Theme.of(context).colorScheme.background,
                              text: "Emoji",
                              onPressed: (() async {
                                setState(() {
                                  type = Type.emoji;
                                });
                                refreshOverlay();
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SearchInputField(
                      //fillColor: Theme.of(context).colorScheme.surfaceVariant,
                      controller: searchController,
                      hint: getTypeInfo(type ?? Type.gif),
                      onChanged: _onChange,
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
      return EmojiSearchDialog(key: childkey);
    } else {
      return const SizedBox();
    }
  }
}

enum Type {
  gif,
  emoji,
}
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../enums/screen_type.dart';

class GifSearchDialog extends StatefulWidget {
  const GifSearchDialog({Key? key}) : super(key: key);

  @override
  GifSearchDialogState createState() => GifSearchDialogState();
}

class GifSearchDialogState extends State<GifSearchDialog> {
  final TextEditingController searchController = TextEditingController();
  OverlayEntry? overlayEntry;
  List<String> gifUrls = [];
  late String tenorapiKey;
  bool isHovering = false;

  @override
  void initState() {
    super.initState();
    overlayEntry = OverlayEntry(builder: (context) => buildOverlay(context));
    WidgetsBinding.instance.addPostFrameCallback((_) => showOverlay());
    tenorapiKey = dotenv.env['TENOR_API_KEY'] ?? '';
    fetchGifs('nexis');
  }

  @override
  void dispose() {
    if (overlayEntry?.mounted ?? false) {
      overlayEntry?.remove();
    }
    super.dispose();
  }

  void showOverlay() {
    Overlay.of(context).insert(overlayEntry!);
  }

  Future<void> fetchGifs(String term) async {
    if (term.isEmpty || term.trim().isEmpty) {
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
            'https://tenor.googleapis.com/v2/search?q=$term&key=$tenorapiKey&media_filter=gif&limit=100'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        List<dynamic> results = jsonResponse['results'];
        setState(() {
          gifUrls = results
              .map((result) {
                return result['media_formats'] != null &&
                        result['media_formats']['gif'] != null &&
                        result['media_formats']['gif']['url'] != null
                    ? result['media_formats']['gif']['url']
                    : null;
              })
              .where((url) => url != null)
              .toList()
              .cast<String>();
        });
      } else {
        throw Exception('Failed to load GIFs from Tenor');
      }
    } catch (e) {
      throw Exception('Failed to load GIFs from Tenor: $e');
    }
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
          right: screenType == ScreenType.desktop ? 240.0 : 15,
          bottom: 80,
          child: Material(
            borderRadius: BorderRadius.circular(10),
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
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Search in Tenor',
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                      ),
                      onChanged: (value) {
                        fetchGifs(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        children: List.generate(
                          100,
                          (index) {
                            if (gifUrls.length > index) {
                              ValueNotifier<bool> isHovering =
                                  ValueNotifier(false);
                              return MouseRegion(
                                onHover: (event) {
                                  isHovering.value = true;
                                },
                                onExit: (event) {
                                  isHovering.value = false;
                                },
                                child: ValueListenableBuilder<bool>(
                                  valueListenable: isHovering,
                                  builder: (context, isHoveringValue, child) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context, gifUrls[index]);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: isHoveringValue
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .secondary
                                                  : Colors.transparent,
                                              width: 3.0,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl: gifUrls[index],
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
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
}

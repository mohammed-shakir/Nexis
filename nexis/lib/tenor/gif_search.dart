import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class GifSearchDialog extends StatefulWidget {
  const GifSearchDialog({Key? key}) : super(key: key);

  @override
  GifSearchDialogState createState() => GifSearchDialogState();
}

class GifSearchDialogState extends State<GifSearchDialog> {
  ValueNotifier<List<String>> gifUrls = ValueNotifier([]);
  late String tenorapiKey;
  bool isHovering = false;

  @override
  void initState() {
    super.initState();
    tenorapiKey = dotenv.env['TENOR_API_KEY'] ?? '';
    fetchGifs('nexis');
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchGifs(String term) async {
    try {
      if (term.isEmpty || term.trim().isEmpty) {
        term = 'nexis';
      }

      final response = await http.get(
        Uri.parse(
            'https://tenor.googleapis.com/v2/search?q=$term&key=$tenorapiKey&media_filter=gif&limit=100'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        List<dynamic> results = jsonResponse['results'];
        List<String> fetchedGifs = results
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
        gifUrls.value = fetchedGifs;
      } else {
        throw Exception('Failed to load GIFs from Tenor');
      }
    } catch (e) {
      throw Exception('Failed to load GIFs from Tenor: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ValueListenableBuilder<List<String>>(
          valueListenable: gifUrls,
          builder: (context, value, child) {
            return GridView.count(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              crossAxisCount: 2,
              children: List.generate(
                value.length,
                (index) {
                  if (value.length > index) {
                    ValueNotifier<bool> isHovering = ValueNotifier(false);
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
                              Navigator.pop(context, value[index]);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
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
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    key: UniqueKey(),
                                    imageUrl: value[index],
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
            );
          },
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class GifSearchDialog extends StatefulWidget {
  final TextEditingController searchController;
  final String initialSearchTerm;

  const GifSearchDialog({Key? key, required this.searchController, required this.initialSearchTerm}) : super(key: key);

  @override
  GifSearchDialogState createState() => GifSearchDialogState();
}

class GifSearchDialogState extends State<GifSearchDialog> {
  ValueNotifier<List<String>> gifUrls = ValueNotifier([]);
  late String tenorapiKey;
  bool isLoading = false;
  String? nextToken;
  late List<ValueNotifier<bool>> hoverStates;
  String currentSearchTerm = 'nexis';

  @override
  void initState() {
    super.initState();
    tenorapiKey = dotenv.env['TENOR_API_KEY'] ?? '';
    currentSearchTerm = widget.initialSearchTerm;
    fetchGifs(currentSearchTerm);
  }

  Future<void> fetchGifs(String term, {bool loadMore = false}) async {
    if (isLoading) {
      return;
    }
    isLoading = true;

    if (!loadMore) {
      currentSearchTerm = term.isEmpty ? 'nexis' : term;
    }

    try {
      String url = 'https://tenor.googleapis.com/v2/search?q=$currentSearchTerm&key=$tenorapiKey&media_filter=gif&limit=10';
      if (loadMore && nextToken != null) {
        url += '&pos=$nextToken';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        List<dynamic> results = jsonResponse['results'];

        nextToken = jsonResponse['next'];

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

        if (loadMore) {
          gifUrls.value = [...gifUrls.value, ...fetchedGifs];
        } else {
          gifUrls.value = fetchedGifs;
        }
      } else {
        throw Exception('Failed to load GIFs from Tenor');
      }
    } catch (e) {
      throw Exception('Failed to load GIFs from Tenor: $e');
    } finally {
      isLoading = false;
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
            hoverStates = List.generate(value.length, (_) => ValueNotifier(false));

            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  fetchGifs(currentSearchTerm, loadMore: true);
                }
                return true;
              },
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return buildGifItem(context, value, index);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildGifItem(BuildContext context, List<String> value, int index) {
    return MouseRegion(
      onEnter: (event) => hoverStates[index].value = true,
      onExit: (event) => hoverStates[index].value = false,
      child: ValueListenableBuilder<bool>(
        valueListenable: hoverStates[index],
        builder: (context, isHovering, child) {
          return GestureDetector(
            onTap: () => Navigator.pop(context, value[index]),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isHovering ? Theme.of(context).colorScheme.secondary : Colors.transparent,
                    width: 3.0,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: value[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'dart:html';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GifSearchDialog extends StatefulWidget {
  final Offset buttonPosition;
  GifSearchDialog(this.buttonPosition);
  @override
  GifSearchDialogState createState() => GifSearchDialogState();
}

class GifSearchDialogState extends State<GifSearchDialog> {
  final TextEditingController searchController = TextEditingController();
  OverlayEntry? overlayEntry;
  List<String> gifUrls = [];
  late String tenorapiKey;
  @override
  void initState() {
    super.initState();
    overlayEntry = OverlayEntry(builder: (context) => buildOverlay(context));
    WidgetsBinding.instance?.addPostFrameCallback((_) => showOverlay());
    tenorapiKey = dotenv.env['TENOR_API_KEY'] ?? '';
    fetchGifs('ben_yes');
  }

  @override
  void dispose() {
    overlayEntry?.remove();
    super.dispose();
  }

  void showOverlay() {
    Overlay.of(context)?.insert(overlayEntry!);
  }

  Future<void> fetchGifs(String term) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://tenor.googleapis.com/v2/search?q=$term&key=$tenorapiKey&media_filter=gif&limit=9'),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response parse JSÓN
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        List<dynamic> results = jsonResponse['results'];
        if (results != null) {
          // uppdaterar
          setState(() {
            gifUrls = results
                .map((result) {
                  return result['media_formats'] != null &&
                          result['media_formats']['gif'] != null &&
                          result['media_formats']['gif']['url'] != null
                      ? result['media_formats']['gif']['url']
                      : null;
                })
                .where((url) => url != null) // Remove null URLs
                .toList()
                .cast<String>();
          });
        }
      } else {
        // If the server returns an unsuccessful response code, throw an exception.
        throw Exception('Failed to load GIFs from Tenor');
      }
    } catch (e) {
      print('Failed to fetch GIFs: $e');
    }
  }

  Widget buildOverlay(BuildContext context) {
    return GestureDetector(
      onTap: () {
        overlayEntry
            ?.remove(); // Close the dialog when user tap outside the search bar
        Navigator.pop(context);
      },
      child: Container(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              top: widget.buttonPosition.dy - 500,
              left: widget.buttonPosition.dx - 500,
            ),
            child: Material(
              child: Container(
                width: 500,
                height: 600,
                child: Column(
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Search in Tenor',
                      ),
                      onSubmitted: (value) {
                        fetchGifs(value);
                      },
                    ),
                    SizedBox(height: 20),
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      children: List.generate(
                        9,
                        (index) {
                          if (gifUrls.length > index) {
                            return GestureDetector(
                              onTap: () {
                                //returns the gifUrls[index] depending on which one you presseed
                                Navigator.pop(context, gifUrls[index]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 100,
                                  height: 75,
                                  child: CachedNetworkImage(
                                    imageUrl: gifUrls[index],
                                    fit: BoxFit.cover,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}

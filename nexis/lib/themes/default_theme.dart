import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xFF171c2a), // Usually used for background
    secondary: const Color(0xFF800020), // Usually used for buttons and stuff
    tertiary: const Color(0xFF606060),
    outline: const Color(0xFF171c2a),
  ),
  textTheme: const TextTheme(
    // Title
    displayLarge: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 30,
    ),
    // bodyMedium
    displayMedium: TextStyle(
      color: Colors.white,
      fontFamily: 'Arial',
      fontSize: 16,
    ),
    labelLarge: TextStyle(
      color: Colors.white,
      fontFamily: 'Arial',
      fontSize: 18,
    ),
    labelMedium: TextStyle(
      color: Colors.grey, 
      fontWeight: FontWeight.bold, 
      fontFamily: 'Arial', 
      fontSize: 16,
    ),
    // Hyperlink
    bodyMedium: TextStyle(
      color: Color.fromARGB(255, 227, 69, 69),
      fontWeight: FontWeight.bold,
      fontFamily: 'Arial',
      fontSize: 16,
    ),
    labelSmall: TextStyle(
      color: Colors.grey,
      fontFamily: 'Arial',
      fontSize: 14,
    ),
  ),
  scrollbarTheme: ScrollbarThemeData(
    thumbColor: MaterialStateProperty.all(Colors.black),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    selectionColor: Colors.blue, // set the color for selected text
  ),
  scaffoldBackgroundColor: const Color(0xFF242C40),
);

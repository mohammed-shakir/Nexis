import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xFF171c2a), // Usually used for background
    secondary: const Color(0xFF800020), // Usually used for buttons and stuff
    tertiary: const Color(0xFF606060),
    background: const Color.fromARGB(255, 21, 25, 37),
    onBackground: const Color.fromARGB(255, 15, 18, 28),
  ),
  textTheme: const TextTheme(
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
  ),
  scrollbarTheme: ScrollbarThemeData(
    thumbColor: MaterialStateProperty.all(Colors.black),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    selectionColor: Colors.blue, // set the color for selected text
  ),
);

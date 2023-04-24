import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  // backgroundColor: const Color(0xFF800020),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xFF171c2a), // Usually used for background
    secondary: const Color(0xFF800020), // Usually used for buttons and stuff
  ),
  textTheme: const TextTheme(
    // bodyMedium
    displayMedium: TextStyle(
    color: Colors.white,
    fontFamily: 'Arial',
    fontSize: 12,
    ),
    // button text
    labelLarge: TextStyle(
    color: Colors.white,
    fontFamily: 'Arial',
    fontSize: 16,
    ),
  ),
);

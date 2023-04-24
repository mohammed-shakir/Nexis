import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xFF171c2a), // Usually used for background
    secondary: const Color(0xFF800020), // Usually used for buttons and stuff
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
);

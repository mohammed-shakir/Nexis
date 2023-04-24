import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  // backgroundColor: const Color(0xFF800020),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xFF171c2a),
    secondary: const Color(0xFF800020),
  ),
  textTheme: const TextTheme(
    // bodyMedium
    displayMedium: TextStyle(
      color: Colors.white,
      fontFamily: 'Arial',
      fontSize: 12,
    ),
  ),
);

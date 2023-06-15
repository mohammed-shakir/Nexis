import 'package:flutter/material.dart';

enum ScreenType {
  mobile,
  tablet,
  desktop,
}

ScreenType getScreenType(MediaQueryData mediaQuery) {
  double deviceWidth = mediaQuery.size.width;

  if (deviceWidth > 1000) {
    return ScreenType.desktop;
  }

  if (deviceWidth > 450) {
    return ScreenType.tablet;
  }

  return ScreenType.mobile;
}
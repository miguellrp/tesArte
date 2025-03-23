import 'package:flutter/material.dart';

class UtilViewport {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  static bool isNarrowScreen(BuildContext context) {
    return MediaQuery.sizeOf(context).width <= 350;
  }
}
import 'package:flutter/material.dart';

class UtilText {
  /// Shorten a text to a certain number of lines
  static Text getEllipsizedText(String text, {int maxLines = 1, TextAlign? textAlign = TextAlign.center, TextStyle? style}) {
    return Text(text, textAlign: textAlign, maxLines: maxLines, overflow: TextOverflow.ellipsis, style: style);
  }

  /// Check if a string is an integer number (not floating point included)
  static bool isIntegerNumber(String? value) {
    bool isIntegerNumber = true;

    try {
      int.parse(value!);
    } catch (e) {
      isIntegerNumber = false;
    }

    return isIntegerNumber;
  }

  /// Check if a string is a numeric value (floating points included)
  static bool isNumeric(String? value) {
    bool isNumeric = true;

    try {
      double.parse(value!);
    } catch (e) {
      isNumeric = false;
    }

    return isNumeric;
  }
}
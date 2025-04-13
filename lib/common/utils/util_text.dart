import 'package:flutter/material.dart';

class UtilText {
  static Text getEllipsizedText(String text, {int maxLines = 1, TextAlign? textAlign = TextAlign.center, TextStyle? style}) {
    return Text(text, textAlign: textAlign, maxLines: maxLines, overflow: TextOverflow.ellipsis, style: style);
  }
}
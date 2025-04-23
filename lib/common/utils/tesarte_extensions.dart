import 'package:flutter/material.dart';

extension ValidationEmptyValue on String? {
  bool get isEmptyOrNull {
    return this == "" || this == null;
  }

  bool get isNotEmptyAndNotNull {
    return this != "" && this != null;
  }
}

extension DarkenLightenColorExtension on Color {
  /* Darken and Lighten extensions thanks to @Tien Do Nam: https://stackoverflow.com/a/75514666 */
  Color darken({double percent = 0.1}) {
    assert(0 <= percent && percent <= 1);

    return Color.lerp(this, Colors.black, percent)!;
  }

  Color lighten({double percent = 0.1}) {
    assert(0 <= percent && percent <= 1);

    return Color.lerp(this, Colors.white, percent)!;
  }
}
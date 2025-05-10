import 'package:flutter/material.dart';
import 'package:tesArte/app_config/router.dart';

// TODO: refactor into
class UtilStyle {
  static BoxDecoration getFormFieldDecoration() {
    return BoxDecoration(
      border: Border.all(color: Theme.of(navigatorKey.currentContext!).colorScheme.onPrimary.withAlpha(180)),
      borderRadius: BorderRadius.circular(5),
    );
  }
}
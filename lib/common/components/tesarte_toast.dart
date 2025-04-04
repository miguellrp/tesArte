import 'package:flutter/material.dart';

enum TesArteToastType {
  error,
  success,
  warning
}

class TesArteToast {
  static showErrorToast(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 12,
      width: 350,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      backgroundColor: Colors.redAccent,
      content: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          Icon(Icons.error, color: Colors.white),
          Text(message, style: TextStyle(color: Colors.white)),
        ],
      ),
    ));
  }

  static showSuccessToast(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.greenAccent,
      content: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          Icon(Icons.check_circle, color: Colors.greenAccent),
          Text(message, style: TextStyle(color: Colors.green)),
        ],
      ),
    ));
  }

  static showWarningToast(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.orange,
      content: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          Icon(Icons.warning, color: Colors.orangeAccent),
          Text(message, style: TextStyle(color: Colors.orangeAccent)),
        ],
      ),
    ));
  }
}
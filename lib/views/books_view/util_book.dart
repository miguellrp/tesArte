import 'package:flutter/material.dart';

class UtilBook {
  static String getStatusText(int? statusBook) {
    String statusText;

    // ⬇️ TODO: lang ⬇️
    switch (statusBook) {
      case 1: statusText = "Lendo";
      case 2: statusText = "Lido";
      default: statusText = "Pendente";
    }

    return statusText;
  }

  static Color getStatusColor(int? statusBook) {
    Color statusColor;

    switch (statusBook) {
      case 1: statusColor = Colors.blueAccent;
      case 2: statusColor = Colors.green;
      default: statusColor = Colors.orangeAccent;
    }

    return statusColor;
  }
}
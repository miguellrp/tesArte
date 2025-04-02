class UtilDate {
  static bool isDateTime(String dateString) {
    bool isDateTime = true;

    try {
      DateTime.parse(dateString);
    } catch (exception) {
      isDateTime = false;
    }

    return isDateTime;
  }
}
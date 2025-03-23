extension ValidationEmptyValue on String? {
  bool isEmptyOrNull() {
    return this == "" || this == null;
  }

  bool isNotEmptyAndNotNull() {
    return this != "" && this != null;
  }
}
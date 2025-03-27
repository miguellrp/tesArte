extension ValidationEmptyValue on String? {
  bool get isEmptyOrNull {
    return this == "" || this == null;
  }

  bool get isNotEmptyAndNotNull {
    return this != "" && this != null;
  }
}
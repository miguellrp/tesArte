class Book {
  static final String _tableName = 't_book';

  String? bookId;
  String? title;
  String? subtitle;
  int? publicationYear;
  String? authorFullName;
  String? description;
  String? imageUrl;

  bool errorDB = false;
  String? errorDBType;

  Book({
    this.bookId,
    this.title,
    this.subtitle,
    this.publicationYear,
    this.authorFullName,
    this.description,
    this.imageUrl
  });
}
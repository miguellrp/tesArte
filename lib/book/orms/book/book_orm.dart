class BookORM {
  int? bookId;
  int? userId;
  String? title;
  String? subtitle;
  int? publishedYear;
  String? googleBookId;
  String? description;
  String? coverImagePath;
  double? rating;
  int? status; // 0 → TO BE READ, 1 → READING, 2 → READ
  DateTime? additionDate;

  BookORM({
    this.userId,
    this.title,
    this.subtitle,
    this.publishedYear,
    this.googleBookId,
    this.description,
    this.coverImagePath,
    this.rating,
    this.status = 0,
    this.additionDate
  });
}
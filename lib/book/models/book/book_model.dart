import 'package:tesArte/book/orms/book/book_orm.dart';

class BookModel {
  final BookORM _bookORM;
  BookModel({BookORM? bookORM}) : _bookORM = bookORM ?? BookORM();

  // *** GETTERS/SETTERS ***
  int? get bookId => _bookORM.bookId;
  set bookId(int? bookId) => _bookORM.bookId = bookId;

  int? get userId => _bookORM.userId;
  set userId(int? userId) => _bookORM.userId = userId;

  String? get title => _bookORM.title;
  set title(String? title) => _bookORM.title = title;

  String? get subtitle => _bookORM.subtitle;
  set subtitle(String? subtitle) => _bookORM.subtitle = subtitle;

  int? get publishedYear => _bookORM.publishedYear;
  set publishedYear(int? publishedYear) => _bookORM.publishedYear = publishedYear;

  String? get googleBookId => _bookORM.googleBookId;
  set googleBookId(String? googleBookId) => _bookORM.googleBookId = googleBookId;

  String? get description => _bookORM.description;
  set description(String? description) => _bookORM.description = description;

  String? get coverImagePath => _bookORM.coverImagePath;
  set coverImagePath(String? coverImagePath) => _bookORM.coverImagePath = coverImagePath;

  double? get rating => _bookORM.rating;
  set rating(double? rating) => _bookORM.rating = rating;

  int? get status => _bookORM.status;
  set status(int? status) => _bookORM.status = status;

  DateTime? get additionDate => _bookORM.additionDate;
  set additionDate(DateTime? additionDate) => _bookORM.additionDate = additionDate;
  // ***********************
}
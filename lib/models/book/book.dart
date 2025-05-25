import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tesArte/common/placeholders/book_placeholder/book_placeholder.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';
import 'package:tesArte/common/utils/util_text.dart';
import 'package:tesArte/data/tesarte_domain.dart';
import 'package:tesArte/data/tesarte_db_helper.dart';
import 'package:tesArte/models/book/google_book.dart';
import 'package:transparent_image/transparent_image.dart';

class Book {
  static final String tableName = 't_book';

  static final double bookCoverMiniatureWidth = 128;
  static final double bookCoverMiniatureHeight = 183;

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

  bool errorDB = false;
  String? errorDBType;

  Book({
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

  Book.fromMap(Map<String, dynamic> map) {
    bookId = int.parse(map["a_book_id"].toString());
    userId = int.parse(map["a_user_id"].toString());
    title = map["a_title"]?.toString();
    subtitle = map["a_subtitle"]?.toString();
    publishedYear = UtilText.isIntegerNumber(map["a_published_year"].toString()) ? int.parse(map["a_published_year"].toString()) : null;
    googleBookId = map["a_google_book_id"]?.toString();
    description = map["a_description"]?.toString();
    coverImagePath = map["a_cover_image_path"]?.toString(); // TODO: format correctly null values
    rating = UtilText.isNumeric(map["a_rating"].toString()) ? double.parse(map["a_rating"].toString()) : null;
    status = UtilText.isIntegerNumber(map["a_status"].toString()) ? int.parse(map["a_status"].toString()) : 0;
    additionDate = DateTime.tryParse(map["a_addition_date"].toString());
  }

  Map<String, Object?> toMap() {
    return {
      "a_book_id": bookId,
      "a_user_id": userId,
      "a_title": title,
      "a_subtitle": subtitle,
      "a_published_year": publishedYear,
      "a_google_book_id": googleBookId,
      "a_description": description,
      "a_cover_image_path": coverImagePath,
      "a_rating": rating,
      "a_status": status
    };
  }

  /* --- CRUD OPERATIONS --- */
  Future<void> add() async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();

    try {
      if (!errorDB) {
        bookId = await tesArteDB.insert(tableName,
          toMap(),
          conflictAlgorithm: ConflictAlgorithm.abort,
        );
      }
    } catch (exception) {
      errorDB = true;

      if (exception is DatabaseException) {
        if (exception.toString().contains("UNIQUE constraint failed: T_BOOK.a_google_book_id")) {
          errorDBType = "CONSTRAINT ERROR: Book already exists in database";
        }
      }

      if (errorDBType.isEmptyOrNull) errorDBType = exception.toString();
    }
  }

  Future<void> update() async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();
    late int booksUpdated; // TODO: allow multiple updates [❓]

    try {
      booksUpdated = await tesArteDB.update(tableName,
        toMap(),
        where: "a_book_id = ?",
        whereArgs: [bookId]
      );
    } catch (exception) {
      errorDB = true;

      if (errorDBType.isEmptyOrNull) errorDBType = exception.toString();
    }
  }

  Future<int> deleteBook() async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();
    int booksDeleted = 0; // TODO: allow multiple deletes

    try {
      booksDeleted = await tesArteDB.delete(tableName,
        where: "a_book_id = ?",
        whereArgs: [bookId]
      );
    } catch (exception) {
      errorDB = true;
      errorDBType = exception.toString();
    }

    return booksDeleted;
  }

  /* --- GETTERS --- */
  ClipRRect getCoverImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: coverImagePath.isNotEmptyAndNotNull ? FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: coverImagePath!,
      ) : BookPlaceholder(),
    );
  }


  /* --- STATIC METHODS --- */
  static Book fromGoogleBook(GoogleBook googleBook){
    return Book(
      title: googleBook.title,
      subtitle: googleBook.subtitle,
      publishedYear: googleBook.publishedYear,
      googleBookId: googleBook.id,
      description: _shortenDescriptionFromGoogleBook(googleBook.description),
      coverImagePath: googleBook.coverImageUrl
    );
  }

  static String? _shortenDescriptionFromGoogleBook(String? googleBookDescription) {
    String? description;

    if (googleBookDescription.isNotEmptyAndNotNull) {
      description = googleBookDescription!.length <= TesArteDomain.dDescription ? googleBookDescription : googleBookDescription.substring(0, TesArteDomain.dDescription);
    }

    return description;
  }
}
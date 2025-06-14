import 'package:sqflite/sqflite.dart';
import 'package:tesArte/books/books_db_filters.dart';
import 'package:tesArte/books/models/book_model.dart';
import 'package:tesArte/books/models/google_book.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';
import 'package:tesArte/common/utils/util_text.dart';
import 'package:tesArte/data/tesarte_db_helper.dart';
import 'package:tesArte/data/tesarte_domain.dart';
import 'package:tesArte/models/model_list.dart';
import 'package:tesArte/models/tesarte_session/tesarte_session.dart';

class BookController {
  static final _tableName = "t_book";
  final BookModel _model;
  bool errorDB = false;
  String? errorDBType;

  BookController({required BookModel model}) : _model = model;

  BookModel get model => _model;

  BookController.fromMap(Map<String, dynamic> map, this._model) {
    model.bookId = int.parse(map["a_book_id"].toString());
    model.userId = int.parse(map["a_user_id"].toString());
    model.title = map["a_title"]?.toString();
    model.subtitle = map["a_subtitle"]?.toString();
    model.publishedYear = UtilText.isIntegerNumber(map["a_published_year"].toString()) ? int.parse(map["a_published_year"].toString()) : null;
    model.googleBookId = map["a_google_book_id"]?.toString();
    model.description = map["a_description"]?.toString();
    model.coverImagePath = map["a_cover_image_path"]?.toString(); // TODO: format correctly null values
    model.rating = UtilText.isNumeric(map["a_rating"].toString()) ? double.parse(map["a_rating"].toString()) : null;
    model.status = UtilText.isIntegerNumber(map["a_status"].toString()) ? int.parse(map["a_status"].toString()) : 0;
    model.additionDate = DateTime.tryParse(map["a_addition_date"].toString());
  }

  Map<String, Object?> toMap() {
    return {
      "a_book_id": model.bookId,
      "a_user_id": model.userId,
      "a_title": model.title,
      "a_subtitle": model.subtitle,
      "a_published_year": model.publishedYear,
      "a_google_book_id": model.googleBookId,
      "a_description": model.description,
      "a_cover_image_path": model.coverImagePath,
      "a_rating": model.rating,
      "a_status": model.status
    };
  }

  /* --- CRUD OPERATIONS --- */
  Future<ModelList<BookController>> getFromActiveUser({String? termFiltered}) async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();
    ModelList<BookController> books = ModelList<BookController>();

    try {
      String whereQuery = BooksDBFilters.userId.whereQuery;
      final List<Object?> whereArgs = [TesArteSession.instance.getActiveUser()!.userId];

      if (termFiltered.isNotEmptyAndNotNull) {
        whereQuery += " AND (${BooksDBFilters.title.whereLowerLikeQuery} OR ${BooksDBFilters.subtitle.whereLowerLikeQuery})";
        whereArgs.addAll([termFiltered, termFiltered]);
      }

      books = ModelList<BookController>(modelList: await tesArteDB.query(_tableName,
          where: whereQuery,
          whereArgs: whereArgs,
          orderBy: "a_addition_date DESC"
      ).then((booksMapList) => booksMapList.map((dataBook) {
        final BookModel newModel = BookModel();
        return BookController.fromMap(dataBook, newModel);
      }).toList()));
    } catch (exception) {
      errorDB = true;
      errorDBType = exception.toString();
    }

    return books;
  }

  Future<void> add() async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();

    try {
      model.bookId = await tesArteDB.insert(_tableName,
        toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
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
      booksUpdated = await tesArteDB.update(_tableName,
          toMap(),
          where: "a_book_id = ?",
          whereArgs: [model.bookId]
      );
    } catch (exception) {
      errorDB = true;

      if (errorDBType.isEmptyOrNull) errorDBType = exception.toString();
    }
  }

  Future<int> delete() async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();
    int booksDeleted = 0; // TODO: allow multiple deletes

    try {
      booksDeleted = await tesArteDB.delete(_tableName,
          where: "a_book_id = ?",
          whereArgs: [model.bookId]
      );
    } catch (exception) {
      errorDB = true;
      errorDBType = exception.toString();
    }

    return booksDeleted;
  }

  /* --- STATIC METHODS --- */
  static BookController fromGoogleBook(GoogleBook googleBook){
    return BookController(model: BookModel()
      ..title = googleBook.title
      ..subtitle = googleBook.subtitle
      ..publishedYear = googleBook.publishedYear
      ..googleBookId = googleBook.id
      ..description = _shortenDescriptionFromGoogleBook(googleBook.description)
      ..coverImagePath = googleBook.coverImageUrl
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
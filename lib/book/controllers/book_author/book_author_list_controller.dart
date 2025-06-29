import 'package:sqflite/sqflite.dart';
import 'package:tesArte/book/controllers/book/book_controller.dart';
import 'package:tesArte/book/controllers/book_author/book_author_controller.dart';
import 'package:tesArte/book/models/book/google_book.dart';
import 'package:tesArte/book/models/book_author/book_author_model.dart';
import 'package:tesArte/book/orms/book_author/book_author_orm.dart';
import 'package:tesArte/data/tesarte_db_helper.dart';
import 'package:tesArte/models/model_list.dart';

class BookAuthorListController extends ModelList<BookAuthorController> {
  bool errorDB = false;
  String? errorDBType;

  BookAuthorListController();

  /* --- CRUD OPERATIONS --- */
  Future<void> getAll() async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();

    try {
      addAll(ModelList<BookAuthorController>(modelList: await tesArteDB.query(BookAuthorController.tableName,
      ).then((bookAuthorsList) => bookAuthorsList.map((bookAuthorData) {
        final BookAuthorModel newModel = BookAuthorModel();
        return BookAuthorController.fromMap(bookAuthorData, newModel);
      }).toList())));
    } catch (exception) {
    errorDB = true;
    errorDBType = exception.toString();
    }
  }

  Future<void> getFromBook(BookController book) async {
    try {
      addAll(ModelList<BookAuthorController>(modelList: await _queryFromBook(book: book).then((bookAuthorsList) => bookAuthorsList.map((bookAuthorData) {
        final BookAuthorModel newModel = BookAuthorModel();
        return BookAuthorController.fromMap(bookAuthorData, newModel);
      }).toList())));
    } catch (exception) {
      errorDB = true;
      errorDBType = exception.toString();
    }
  }

  Future<int> createAuthorsFromGoogleBook(GoogleBook googleBook) async {
    int bookAuthorsCreated = 0;
    List<dynamic> authorNames = googleBook.authorsNames??[];

    for (final String authorName in authorNames) {
      List<String?> authorFullName = authorName.split(" ");
      if (authorFullName.length == 1) authorFullName.insert(1, null);

      final BookAuthorController newBookAuthor = BookAuthorController(
        model: BookAuthorModel(bookAuthorORM: BookAuthorORM(
          firstName: authorFullName[0],
          lastName: authorFullName[1]
        ))
      );
      await newBookAuthor.add();

      if (newBookAuthor.errorDB) {
        errorDB = true;
        errorDBType = newBookAuthor.errorDBType;
      } else {
        add(newBookAuthor);
        bookAuthorsCreated++;
      }
    }

    return bookAuthorsCreated;
  }

  Future<void> deleteFromBook({required BookController book}) async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();

    try {
      await tesArteDB.delete(BookAuthorController.relBookTableName,
          where: "a_book_id = ?",
          whereArgs: [book.model.bookId]
      );
    } catch (exception) {
      errorDB = true;
      errorDBType = exception.toString();
    }
  }

  /* --- UTIL METHODS --- */
  String getAuthorNamesJoined({String separator = " | "}) {
    String authorNamesJoined = "";

    for (int i = 0; i < length; i++) {
      if (i != 0) authorNamesJoined += separator;
      authorNamesJoined += this[i].getFullName();
    }

    return authorNamesJoined;
  }

  /* --- QUERY METHODS --- */
  Future<List<Map<String, Object?>>> _queryFromBook({required BookController book}) async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();

    return await tesArteDB.rawQuery('''
      SELECT tba.*, tbarel.*
      FROM ${BookAuthorController.tableName} tba
      INNER JOIN ${BookAuthorController.relBookTableName} tbarel ON tba.a_book_author_id = tbarel.a_book_author_id
      WHERE tbarel.a_book_id = ?
    ''', [book.model.bookId]);
  }
}
import 'package:sqflite/sqflite.dart';
import 'package:tesArte/data/tesarte_db_helper.dart';
import 'package:tesArte/models/author/book/book_author.dart';
import 'package:tesArte/models/book/book.dart';
import 'package:tesArte/models/model_list.dart';

class BookAuthorList extends ModelList<BookAuthor> {
  bool errorDB;
  String? errorDBType;

  BookAuthorList({List<BookAuthor>? bookAuthorsList, this.errorDB = false, this.errorDBType}) : super(modelList: bookAuthorsList);

  /* --- CRUD OPERATIONS --- */
  Future<void> getFromBook({required Book book}) async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();

    try {
      await tesArteDB.rawQuery(_getFromBookRawQuery(),
        [book.bookId]
      ).then((bookAuthorsMapList) {
        for (final bookAuthorMap in bookAuthorsMapList) {
          add(BookAuthor.fromMap(bookAuthorMap));
        }
      });
    } catch (exception) {
      errorDB = true;
      errorDBType = exception.toString();
    }
  }

  Future<void> addToBook(Book book) async {
    if (isNotEmpty) {
      forEach((BookAuthor bookAuthor) {
        bookAuthor.bookId = book.bookId;
        bookAuthor.addAuthorToBook();

        if (bookAuthor.errorDB) {
          errorDB = true;
          errorDBType = bookAuthor.errorDBType;
        }
      });
    } else {
      final BookAuthor unknownAuthor = BookAuthor(name: "Anónimo"); // TODO: lang
      unknownAuthor.bookId = book.bookId;
      await unknownAuthor.addAuthorToBook();

      if (unknownAuthor.errorDB) {
        errorDB = true;
        errorDBType = unknownAuthor.errorDBType;
      }
    }
  }

  /* --- HELPER OPERATIONS --- */
  List<String> getAllNames() {
    List<String> names = [];

    forEach((BookAuthor bookAuthor) {
      names.add(bookAuthor.name!);
    });

    return names;
  }


  /* --- STATIC PRIVATE METHODS --- */
  static String _getFromBookRawQuery() {
    return "SELECT tba.a_book_id, tba.a_author_id, ta.a_name, ta.a_birth_date"
        " FROM t_book_author tba"
        " JOIN t_author ta ON tba.a_author_id = ta.a_author_id"
        " WHERE tba.a_book_id = ?";
  }
}
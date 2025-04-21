import 'package:sqflite/sqflite.dart';
import 'package:tesArte/common/components/generic/tesarte_toast.dart';
import 'package:tesArte/data/tesarte_db_helper.dart';
import 'package:tesArte/models/author/author.dart';

class BookAuthor extends Author {
  static final String tableName = 't_book_author';

  int? bookAuthorId;
  int? bookId;

  BookAuthor({
    this.bookAuthorId,
    super.authorId,
    super.name,
    this.bookId
  });

  BookAuthor.fromMap(Map<String, Object?> map) : super.fromMap(map) {
    bookId = int.parse(map["a_book_id"].toString());
  }

  @override
  Map<String, Object?> toMap() {
    return {
      "a_book_author_id": bookAuthorId,
      "a_author_id": super.toMap()["a_author_id"],
      "a_book_id": bookId
    };
  }

  /* --- CRUD OPERATIONS --- */
  Future<void> addAuthorToBook() async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();
    try {
        await tesArteDB.insert(tableName,
          toMap(),
          conflictAlgorithm: ConflictAlgorithm.abort,
        );
    } catch (exception) {
      errorDB = true;
      errorDBType = exception.toString();
    }
  }

  Future<void> deleteAuthorFromBook() async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();
    try {
      await tesArteDB.delete(tableName,
        where: "a_book_id = ? AND a_author_id = ?",
        whereArgs: [bookId, authorId],
      );
    } catch (exception) {
      errorDB = true;
      errorDBType = exception.toString();
    }
  }
}
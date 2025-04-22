import 'package:sqflite/sqflite.dart';
import 'package:tesArte/data/tesarte_db_helper.dart';
import 'package:tesArte/models/author/author.dart';
import 'package:tesArte/models/author/book_author.dart';
import 'package:tesArte/models/book/book.dart';
import 'package:tesArte/models/model_list.dart';
import 'package:tesArte/models/tesarte_session/tesarte_session.dart';

class BookList {
  ModelList<Book> books = ModelList<Book>();

  bool errorDB = false;
  String? errorDBType;

  Future<void> getFromActiveUser({List<String>? whereParams}) async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();

    try {
      books = ModelList<Book>(modelList: await tesArteDB.rawQuery(
        _getRawQuery(whereParams: whereParams),
        [TesArteSession.instance.getActiveUser()!.userId, ...whereParams ?? []]
        ).then((booksMapList) => booksMapList.map((dataBook) => Book.fromMap(dataBook)).toList())
      );
    } catch (exception) {
      errorDB = true;
      errorDBType = exception.toString();
    }
  }

  static String _getRawQuery({List<String>? whereParams}) {
    String rawQuery = "SELECT tb.*, GROUP_CONCAT(ta.a_name, '#') AS authors "
      "FROM ${Book.tableName} AS tb "
      "JOIN ${BookAuthor.tableName} AS tba ON tb.a_book_id = tba.a_book_id "
      "JOIN ${Author.tableName} AS ta ON tba.a_author_id = ta.a_author_id "
      "WHERE tb.a_user_id = ?";

    if (whereParams != null && whereParams.isNotEmpty) {
      rawQuery += " AND UPPER(tb.a_title) LIKE UPPER('%' || ? || '%') OR UPPER(tb.a_subtitle) LIKE UPPER('%' || ? || '%')";
    }

    rawQuery += " GROUP BY tb.a_book_id;";

    return rawQuery;
  }
}
import 'package:sqflite/sqflite.dart';
import 'package:tesArte/data/tesarte_db_helper.dart';
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
      books = ModelList<Book>(modelList: await tesArteDB.query(Book.tableName,
        where: "a_user_id = ?"
            " AND (LOWER(a_title) LIKE LOWER('%' || ? || '%')"
              " OR LOWER(a_subtitle) LIKE LOWER('%' || ? || '%'))",
        whereArgs: [TesArteSession.instance.getActiveUser()!.userId, ...whereParams ?? []],
        orderBy: "a_addition_date DESC"
        ).then((booksMapList) => booksMapList.map((dataBook) => Book.fromMap(dataBook)).toList())
      );
    } catch (exception) {
      errorDB = true;
      errorDBType = exception.toString();
    }
  }
}
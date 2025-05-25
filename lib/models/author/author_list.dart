import 'package:sqflite/sqflite.dart';
import 'package:tesArte/data/tesarte_db_helper.dart';
import 'package:tesArte/models/author/author.dart';
import 'package:tesArte/models/book/google_book.dart';
import 'package:tesArte/models/model_list.dart';

class AuthorList extends ModelList<Author> {
  bool errorDB;
  String? errorDBType;

  AuthorList({List<Author>? authorsList, this.errorDB = false, this.errorDBType}) : super(modelList: authorsList);

  Future<void> getAllAuthorsWithType(AuthorType authorType) async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();

    try {
      await tesArteDB.query(Author.tableName,
        columns: ["a_author_id", "a_name", "a_birth_date"],
        where: "a_author_type = ?",
        whereArgs: [_getAuthorTypeInt(authorType)]
      ).then((authorsList) => authorsList.map((author) => Author.fromMap(author)).toList());
    } catch (exception) {
      errorDB = true;
      errorDBType = exception.toString();
    }
  }

  Future<int> createAuthors(AuthorType authorType) async {
    int authorsCreated = 0;

    if (isNotEmpty) {
      for (final Author author in this) {
        Author newAuthor = Author(name: author.name, authorType: authorType);
        await author.createAuthor();

        if (newAuthor.errorDB) {
          errorDB = true;
          errorDBType = author.errorDBType;
        }
      }
    }

    return authorsCreated;
  }

  Future<int> createAuthorsFromGoogleBook(GoogleBook googleBook) async {
    int authorsCreated = 0;
    List<dynamic>? authorNames = googleBook.authorsNames;
    if (googleBook.authorsNames == null) authorNames = [];

    for (final String authorName in authorNames!) {
      final Author newAuthor = Author(name: authorName, authorType: AuthorType.book);
      await newAuthor.createAuthor();
      add(newAuthor);

      if (newAuthor.errorDB) {
        errorDB = true;
        errorDBType = newAuthor.errorDBType;
      } else {
        authorsCreated++;
      }
    }
    return authorsCreated;
  }


  /* --- STATIC PRIVATE METHODS --- */
  static int _getAuthorTypeInt(AuthorType authorType) {
    switch(authorType) {
      case AuthorType.book: return 0;
      case AuthorType.film: return 1;
      case AuthorType.series: return 2;
      default: return -1;
    }
  }
}
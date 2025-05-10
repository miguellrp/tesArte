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

  Future<int> createAuthors() async {
    int authorsCreated = 0;

    if (isNotEmpty) {
      Future.forEach(this, (Author author) async {
        Author newAuthor = Author(name: author.name);
        await author.createAuthor();

        if (newAuthor.errorDB) {
          errorDB = true;
          errorDBType = author.errorDBType;
        } else {
          Author unknownAuthor = Author(name: "Anónimo"); // TODO: lang
          await unknownAuthor.createAuthor();

          if (unknownAuthor.errorDB) {
            errorDB = true;
            errorDBType = unknownAuthor.errorDBType;
          }
        }
      });
    }

    return authorsCreated;
  }

  Future<int> createAuthorsFromGoogleBook(GoogleBook googleBook) async {
    int authorsCreated = 0;
    List<dynamic>? authorNames = googleBook.authorsNames;
    if (googleBook.authorsNames == null) authorNames = [];

    for (final String authorName in authorNames!) {
      final Author newAuthor = Author(name: authorName);
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
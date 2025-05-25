import 'package:sqflite/sqflite.dart';
import 'package:tesArte/data/tesarte_db_helper.dart';

enum AuthorType {
  generic,  // -1
  book,     // 0
  film,     // 1
  series    // 2
}

class Author {
  static final String tableName = 't_author';

  int? authorId;
  String? name;
  DateTime? birthDate;
  AuthorType? authorType;

  bool errorDB = false;
  String? errorDBType;

  Author({
    this.authorId,
    this.name,
    this.birthDate,
    this.authorType
  });

  Author.fromMap(Map<String, Object?> map) {
    authorId = int.parse(map["a_author_id"].toString());
    name = map["a_name"].toString();
    birthDate = DateTime.tryParse(map["a_birth_date"].toString());
    authorType = _getAuthorType(int.parse(map["a_author_type"].toString()));
  }

  Map<String, Object?> toMap() {
    return {
      "a_author_id": authorId,
      "a_name": name,
      "a_birth_date": birthDate,
      "a_author_type": authorType?.index
    };
  }

  /* --- CRUD OPERATIONS --- */
  Future<void> createAuthor() async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();

    try {
      authorId = await tesArteDB.insert(tableName,
        toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );

      if (authorId == 0) { // if author is already created on DB:
        final Author existingAuthor = Author(name: name);
        authorId = await existingAuthor.getAuthorId();
      }
    } catch (exception) {
      errorDB = true;
      errorDBType = exception.toString();
    }
  }

  Future<int?> getAuthorId() async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();
    int? authorId;

    try {
      authorId = (await tesArteDB.query(tableName,
        columns: ["a_author_id"],
        where: "a_name = ?",
        whereArgs: [name]
      )).first["a_author_id"] as int?;
    } catch (exception) {
      errorDB = true;
      errorDBType = exception.toString();
    }

    return authorId;
  }

  Future<void> deleteAuthor() async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();
    try {
      await tesArteDB.delete(tableName,
        where: "a_author_id = ?",
        whereArgs: [ authorId ]
      );
    } catch (exception) {
      errorDB = true;
      errorDBType = exception.toString();
    }
  }

  /* --- HELPER OPERATIONS --- */
  static AuthorType _getAuthorType(int authorTypeInt) {
    late final AuthorType authorType;

    switch (authorTypeInt) {
      case 0: authorType = AuthorType.book; break;
      case 1: authorType = AuthorType.film; break;
      case 2: authorType = AuthorType.series; break;
      default: authorType = AuthorType.generic; break;
    }

    return authorType;
  }
}
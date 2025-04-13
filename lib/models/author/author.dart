import 'package:sqflite/sqflite.dart';
import 'package:tesArte/data/tesarte_db_helper.dart';

class Author {
  static final String tableName = 't_author';

  int? authorId;
  String? name;
  DateTime? birthDate;

  bool errorDB = false;
  String? errorDBType;

  Author({
    this.authorId,
    this.name,
    this.birthDate
  });

  Author.fromMap(Map<String, Object?> map) {
    authorId = int.parse(map["a_author_id"].toString());
    name = map["a_name"].toString();
    birthDate = DateTime.tryParse(map["a_birth_date"].toString());
  }

  Map<String, Object?> toMap() {
    return {
      "a_author_id": authorId,
      "a_name": name,
      "a_birth_date": birthDate,
    };
  }

  /* --- CRUD OPERATIONS --- */
  Future<void> add() async {
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

  Future<void> delete() async {
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
}
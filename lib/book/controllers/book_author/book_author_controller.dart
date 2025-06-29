import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tesArte/app_config/router.dart';
import 'package:tesArte/book/controllers/book/book_controller.dart';
import 'package:tesArte/book/models/book_author/book_author_model.dart';
import 'package:tesArte/common/placeholders/tesarte_loader/tesarte_mask_painter.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';
import 'package:tesArte/data/tesarte_db_helper.dart';

class BookAuthorController {
  static final String tableName = 't_book_author';
  static final String relBookTableName = 't_book_author_rel_book';

  final BookAuthorModel _model;
  bool errorDB = false;
  String? errorDBType;

  BookAuthorController({BookAuthorModel? model}) : _model = model??BookAuthorModel();

  BookAuthorModel get model => _model;

  BookAuthorController.fromMap(Map<String, dynamic> map, this._model) {
    model.bookAuthorId = int.parse(map["a_book_author_id"].toString());
    model.firstName = map["a_first_name"].toString();
    model.lastName = map["a_last_name"].toString();
    model.birthDate = DateTime.tryParse(map["a_birth_date"].toString());
    model.deathDate = DateTime.tryParse(map["a_death_date"].toString());
    model.picturePath = map["a_picture_path"]?.toString();
  }

  Map<String, Object?> toMap() {
    return {
      "a_book_author_id": model.bookAuthorId,
      "a_first_name": model.firstName,
      "a_last_name": model.lastName,
      "a_birth_date": model.birthDate,
      "a_death_date": model.deathDate,
      "a_picture_path": model.picturePath
    };
  }

  /* --- CRUD OPERATIONS --- */
  Future<void> add() async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();

    try {
      model.bookAuthorId = await tesArteDB.insert(tableName,
        toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (exception) {
      errorDB = true;
      errorDBType = exception.toString();
    }
  }

  Future<void> addToBook({required BookController book}) async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();

    Map<String, Object?> relData = {
      "a_book_author_id": model.bookAuthorId,
      "a_book_id": book.model.bookId
    };

    try {
      await tesArteDB.insert(relBookTableName,
        relData,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (exception) {
      errorDB = true;
      errorDBType = exception.toString();
    }
  }

  Future<void> update() async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();

    try {
      await tesArteDB.update(tableName,
        toMap(),
        where: "a_book_author_id = ?",
        whereArgs: [model.bookAuthorId]
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
        where: "a_book_author_id = ?",
        whereArgs: [model.bookAuthorId],
      );
    } catch (exception) {
      errorDB = true;
      errorDBType = exception.toString();
    }
  }

  /* --- UTIL METHODS --- */
  String getFullName() {
    String bookAuthorName = model.firstName!;
    if (model.lastName.isNotEmptyAndNotNull) bookAuthorName += " ${model.lastName!}";
    return bookAuthorName;
  }

  ClipRRect getPicture() {
    final CustomPaint picturePlaceholder = CustomPaint(
      painter: TesArteMaskPainter(color: Theme.of(navigatorKey.currentContext!).colorScheme.primary),
      size: Size(30, 30),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      clipBehavior: Clip.hardEdge,
      child: model.picturePath.isNotEmptyAndNotNull
        ? Image.network(model.picturePath!, width: 30, height: 30)
        : picturePlaceholder
    );
  }

  @override
  int get hashCode => model.bookAuthorId!;

  @override
  bool operator == (Object other) => other is BookAuthorController && other.model.bookAuthorId == model.bookAuthorId;
}
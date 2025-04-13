import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TesArteDBHelper {
  static Future<Database> openTesArteDatabase() async {
    return await openDatabase(
      await _getTesArteDBPath(),
      version: 1,
      onCreate: (db, version) async => _createTesArteDatabase(db, version)
    );
  }

  static Future<void> restoreTesArteDatabase() async {
    await _deleteTesArteDatabase();
    await openTesArteDatabase();
  }


  // --- PRIVATE METHODS --- //
  static Future<String> _getTesArteDBPath() async {
    return join(await getDatabasesPath(), 'tesArteDB.db');
  }

  static Future<void> _createTesArteDatabase(Database db, int version) async {
    final String createTesArteDBScript = await _loadSqlScript('lib/data/definition.sql');
    return db.execute(createTesArteDBScript);
  }

  static Future<void> _deleteTesArteDatabase() async {
    try {
      await deleteDatabase(await _getTesArteDBPath());
    } catch (e) {
      print("ERROR: $e");
    }
  }

  static Future<String> _loadSqlScript(String assetPath) async {
    final String sql = await rootBundle.loadString(assetPath);
    return sql;
  }
}
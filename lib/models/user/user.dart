import 'package:tesArte/data/tesarte_db_helper.dart';
import 'package:sqflite/sqflite.dart';

class User {
  static final String _tableName = 't_user';

  String? userId;
  String? userName;
  String? firstName;
  String? lastName;
  DateTime? registerDate;
  DateTime? lastLoginDate;
  DateTime? birthDate;

  bool errorDB = false;
  String? errorDBType;

  User({
    this.userId,
    this.userName,
    this.firstName,
    this.lastName,
    this.registerDate,
  });

  Map<String, Object?> toMap() {
    return {"a_user_id": userId, "a_username": userName, "a_first_name": firstName, "a_last_name": lastName};
  }

  Future<void> createAccount() async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();
    try {
      await tesArteDB.insert(_tableName,
        toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (exception) {
      errorDB = true;
      errorDBType = exception.toString();
    }
  }

  static Future<bool> existsUsersInDB() async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();
    final List<Map<String, Object?>> users = await tesArteDB.query(_tableName);

    return users.isNotEmpty;
  }
}
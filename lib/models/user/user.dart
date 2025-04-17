import 'package:tesArte/data/tesarte_db_helper.dart';
import 'package:sqflite/sqflite.dart';

class User {
  static final String _tableName = 't_user';

  int? userId;
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
    this.lastLoginDate,
    this.birthDate
  });

  Map<String, Object?> toMap() {
    return {
      "a_user_id": userId,
      "a_username": userName,
      "a_first_name": firstName,
      "a_last_name": lastName
    };
  }

  /* --- CRUD OPERATIONS --- */
  Future<void> createAccount() async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();
    try {
      userId = await tesArteDB.insert(_tableName,
        toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (exception) {
      errorDB = true;
      errorDBType = exception.toString();
    }
  }

  Future<void> getLastLoggedUser() async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();

    try {
      final List<Map<String, Object?>> usersMapList = await tesArteDB.query(_tableName,
          orderBy: "a_last_login_date asc",
          limit: 1);
      // TODO: multiple accounts
      Map<String, Object?> firstMap = usersMapList.first;

      userId = int.parse(firstMap["a_user_id"].toString());
      userName = firstMap["a_username"].toString();
      firstName = firstMap["a_first_name"].toString();
      lastName = firstMap["a_last_name"].toString();
      registerDate = DateTime.tryParse(firstMap["a_register_date"].toString());
      lastLoginDate = DateTime.tryParse(firstMap["a_last_login_date"].toString());
      birthDate = DateTime.tryParse(firstMap["a_birth_date"].toString());

    } catch (exception) {
      errorDB = true;
      errorDBType = exception.toString();
    }
  }


  /* --- STATIC METHODS --- */
  static Future<bool> existsUsersInDB() async {
    final Database tesArteDB = await TesArteDBHelper.openTesArteDatabase();
    final List<Map<String, Object?>> users = await tesArteDB.query(_tableName);

    return users.isNotEmpty;
  }

  static User fromMap(Map<String, Object?> map) {
    return User(
      userId: int.parse(map["a_user_id"].toString()),
      userName: map["a_username"].toString(),
      firstName: map["a_first_name"].toString(),
      lastName: map["a_last_name"].toString(),
      registerDate: DateTime.tryParse(map["a_register_date"].toString()),
      lastLoginDate: DateTime.tryParse(map["a_last_login_date"].toString()),
      birthDate: DateTime.tryParse(map["a_birth_date"].toString())
    );
  }
}
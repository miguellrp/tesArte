import 'package:tesArte/models/user/user.dart';

// Singleton Session Class
class TesArteSession {
  TesArteSession._privateConstructor();

  static final TesArteSession _instance = TesArteSession._privateConstructor();

  static TesArteSession get instance => _instance;

  User? user;

  void startSession(User newUser) {
    user = newUser;
  }

  void endSession() {
    user = null;
  }

  User? getActiveUser() {
    return user;
  }
}
